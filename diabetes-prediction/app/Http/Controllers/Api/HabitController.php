<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Habit;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\Rule;
use Carbon\Carbon;
use MongoDB\Database;
use MongoDB\BSON\ObjectId;
use MongoDB\BSON\UTCDateTime;
use Exception;
use DateTime;
use Illuminate\Support\Facades\Log;

class HabitController extends Controller {
    private $db;
    
    public function __construct() {
        try {
            // Ambil koneksi MongoDB langsung dari config
            $host = env('DB_HOST', '127.0.0.1');
            $port = env('DB_PORT', '27017');
            $database = env('DB_DATABASE', 'prediksi_diabetes');
            
            // Add authentication if needed
            $username = env('DB_USERNAME');
            $password = env('DB_PASSWORD');
            
            if ($username && $password) {
                $client = new \MongoDB\Client("mongodb://{$username}:{$password}@{$host}:{$port}");
            } else {
                $client = new \MongoDB\Client("mongodb://{$host}:{$port}");
            }
            
            $this->db = $client->selectDatabase($database);
            
            // Test connection
            $this->db->command(['ping' => 1]);
            
        } catch (Exception $e) {
            Log::error('MongoDB Connection Error: ' . $e->getMessage());
            throw new Exception('Database connection failed: ' . $e->getMessage());
        }
    }
    
    // GET ALL HABITS
    public function getAllHabits(): JsonResponse {
        try {
            $collection = $this->db->selectCollection('targets');
            $cursor = $collection->find();
            
            $habits = [];
            foreach ($cursor as $document) {
                $habit = [
                    '_id' => (string)$document['_id'],
                    'title' => $document['title'] ?? '',
                    'description' => $document['description'] ?? '',
                    'category' => $document['category'] ?? 'regular_habit',
                    'target_type' => $document['target_type'] ?? 'daily',
                    'target_value' => $document['target_value'] ?? 1,
                    'current_progress' => $document['current_progress'] ?? 0,
                    'is_completed' => $document['is_completed'] ?? false,
                    'completion_date' => $this->formatDate($document['completion_date'] ?? null),
                    'created_at' => $this->formatDate($document['created_at'] ?? null),
                    'updated_at' => $this->formatDate($document['updated_at'] ?? null),
                    'last_reset_date' => $this->formatDate($document['last_reset_date'] ?? null)
                ];
                $habits[] = $habit;
            }
            
            return response()->json([
                'status' => 200,
                'message' => 'Success',
                'data' => $habits
            ], 200);
            
        } catch (Exception $e) {
            Log::error('Error fetching habits: ' . $e->getMessage());
            return response()->json([
                'status' => 500,
                'message' => 'Error fetching habits: ' . $e->getMessage()
            ], 500);
        }
    }
    
    // GET HABIT BY ID
    public function getHabitById(string $id): JsonResponse {
        try {
            // Validasi ObjectId format
            if (!$this->isValidObjectId($id)) {
                return response()->json([
                    'status' => 400,
                    'message' => 'Invalid habit ID format'
                ], 400);
            }
            
            $collection = $this->db->selectCollection('targets');
            $document = $collection->findOne(['_id' => new ObjectId($id)]);
            
            if (!$document) {
                return response()->json([
                    'status' => 404,
                    'message' => 'Habit not found'
                ], 404);
            }
            
            $habit = [
                '_id' => (string)$document['_id'],
                'title' => $document['title'] ?? '',
                'description' => $document['description'] ?? '',
                'category' => $document['category'] ?? 'regular_habit',
                'target_type' => $document['target_type'] ?? 'daily',
                'target_value' => $document['target_value'] ?? 1,
                'current_progress' => $document['current_progress'] ?? 0,
                'is_completed' => $document['is_completed'] ?? false,
                'completion_date' => $this->formatDate($document['completion_date'] ?? null),
                'created_at' => $this->formatDate($document['created_at'] ?? null),
                'updated_at' => $this->formatDate($document['updated_at'] ?? null),
                'last_reset_date' => $this->formatDate($document['last_reset_date'] ?? null)
            ];
            
            return response()->json([
                'status' => 200,
                'message' => 'Success',
                'data' => $habit
            ], 200);
            
        } catch (Exception $e) {
            Log::error('Error fetching habit by ID: ' . $e->getMessage());
            return response()->json([
                'status' => 500,
                'message' => 'Error fetching habit: ' . $e->getMessage()
            ], 500);
        }
    }
    
    // CREATE NEW HABIT
    public function createHabit(Request $request): JsonResponse {
        try {
            // Validasi input
            $validatedData = $request->validate([
                'title' => 'required|string|max:255',
                'description' => 'nullable|string|max:1000',
                'category' => 'nullable|string|in:regular_habit,health,fitness,productivity,learning',
                'target_type' => 'nullable|string|in:daily,weekly,monthly,yearly',
                'target_value' => 'nullable|numeric|min:1'
            ]);
            
            $collection = $this->db->selectCollection('targets');
            
            $currentTime = new UTCDateTime();
            
            $habit = [
                'title' => $validatedData['title'],
                'description' => $validatedData['description'] ?? '',
                'category' => $validatedData['category'] ?? 'regular_habit',
                'target_type' => $validatedData['target_type'] ?? 'daily',
                'target_value' => (float)($validatedData['target_value'] ?? 1),
                'current_progress' => 0.0,
                'is_completed' => false,
                'completion_date' => null,
                'created_at' => $currentTime,
                'updated_at' => $currentTime,
                'last_reset_date' => $currentTime
            ];
            
            $result = $collection->insertOne($habit);
            
            if ($result->getInsertedCount() > 0) {
                $habit['_id'] = (string)$result->getInsertedId();
                $habit['created_at'] = $this->formatDate($habit['created_at']);
                $habit['updated_at'] = $this->formatDate($habit['updated_at']);
                $habit['last_reset_date'] = $this->formatDate($habit['last_reset_date']);
                
                return response()->json([
                    'status' => 201,
                    'message' => 'Habit created successfully',
                    'data' => $habit
                ], 201);
            } else {
                return response()->json([
                    'status' => 500,
                    'message' => 'Failed to create habit'
                ], 500);
            }
            
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'status' => 422,
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);
        } catch (Exception $e) {
            Log::error('Error creating habit: ' . $e->getMessage());
            return response()->json([
                'status' => 500,
                'message' => 'Error creating habit: ' . $e->getMessage()
            ], 500);
        }
    }
    
    // UPDATE HABIT
    public function updateHabit(Request $request, string $id): JsonResponse {
        try {
            // Validasi ObjectId format
            if (!$this->isValidObjectId($id)) {
                return response()->json([
                    'status' => 400,
                    'message' => 'Invalid habit ID format'
                ], 400);
            }
            
            // Validasi input
            $validatedData = $request->validate([
                'title' => 'nullable|string|max:255',
                'description' => 'nullable|string|max:1000',
                'category' => 'nullable|string|in:regular_habit,health,fitness,productivity,learning',
                'target_type' => 'nullable|string|in:daily,weekly,monthly,yearly',
                'target_value' => 'nullable|numeric|min:1'
            ]);
            
            $collection = $this->db->selectCollection('targets');
            
            // Check if habit exists first
            $existingHabit = $collection->findOne(['_id' => new ObjectId($id)]);
            if (!$existingHabit) {
                return response()->json([
                    'status' => 404,
                    'message' => 'Habit not found'
                ], 404);
            }
            
            $updateData = [
                'updated_at' => new UTCDateTime()
            ];
            
            if (isset($validatedData['title'])) $updateData['title'] = $validatedData['title'];
            if (isset($validatedData['description'])) $updateData['description'] = $validatedData['description'];
            if (isset($validatedData['category'])) $updateData['category'] = $validatedData['category'];
            if (isset($validatedData['target_type'])) $updateData['target_type'] = $validatedData['target_type'];
            if (isset($validatedData['target_value'])) $updateData['target_value'] = (float)$validatedData['target_value'];
            
            $result = $collection->updateOne(
                ['_id' => new ObjectId($id)],
                ['$set' => $updateData]
            );
            
            if ($result->getModifiedCount() > 0 || $result->getMatchedCount() > 0) {
                return response()->json([
                    'status' => 200,
                    'message' => 'Habit updated successfully'
                ], 200);
            } else {
                return response()->json([
                    'status' => 404,
                    'message' => 'Habit not found'
                ], 404);
            }
            
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'status' => 422,
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);
        } catch (Exception $e) {
            Log::error('Error updating habit: ' . $e->getMessage());
            return response()->json([
                'status' => 500,
                'message' => 'Error updating habit: ' . $e->getMessage()
            ], 500);
        }
    }
    
    // DELETE HABIT
    public function deleteHabit(string $id): JsonResponse {
        try {
            // Validasi ObjectId format
            if (!$this->isValidObjectId($id)) {
                return response()->json([
                    'status' => 400,
                    'message' => 'Invalid habit ID format'
                ], 400);
            }
            
            $collection = $this->db->selectCollection('targets');
            $result = $collection->deleteOne(['_id' => new ObjectId($id)]);
            
            if ($result->getDeletedCount() > 0) {
                return response()->json([
                    'status' => 200,
                    'message' => 'Habit deleted successfully'
                ], 200);
            } else {
                return response()->json([
                    'status' => 404,
                    'message' => 'Habit not found'
                ], 404);
            }
            
        } catch (Exception $e) {
            Log::error('Error deleting habit: ' . $e->getMessage());
            return response()->json([
                'status' => 500,
                'message' => 'Error deleting habit: ' . $e->getMessage()
            ], 500);
        }
    }
    
   // UPDATE PROGRESS (INCREMENT) - FIXED VERSION
public function updateProgress(Request $request, string $id): JsonResponse {
    try {
        // Validasi ObjectId format
        if (!$this->isValidObjectId($id)) {
            return response()->json([
                'status' => 400,
                'message' => 'Invalid habit ID format'
            ], 400);
        }
        
        // Validasi input increment
        $increment = $request->input('increment', 1);
        
        // Handle both string and numeric input
        if (is_string($increment)) {
            $increment = (float)$increment;
        }
        
        if (!is_numeric($increment) || $increment <= 0) {
            return response()->json([
                'status' => 400,
                'message' => 'Increment must be a positive number'
            ], 400);
        }
        
        $collection = $this->db->selectCollection('targets');
        
        // Get current habit data with better error handling
        $habit = $collection->findOne(['_id' => new ObjectId($id)]);
        if (!$habit) {
            return response()->json([
                'status' => 404,
                'message' => 'Habit not found'
            ], 404);
        }
        
        // PERBAIKAN UTAMA: Konversi MongoDB document dengan aman
        $habitArray = [];
        foreach ($habit as $key => $value) {
            $habitArray[$key] = $value;
        }
        
        // Alternative: Gunakan iterator_to_array jika tersedia
        // $habitArray = iterator_to_array($habit);
        
        // Check if habit needs to be reset based on target_type
        $needsReset = $this->checkIfNeedsReset($habitArray);
        
        $updateData = [];
        $currentTime = new UTCDateTime();
        
        if ($needsReset) {
            // Reset progress and update reset date
            $updateData['current_progress'] = (float)$increment;
            $updateData['last_reset_date'] = $currentTime;
            $updateData['is_completed'] = false;
            $updateData['completion_date'] = null;
        } else {
            // Increment progress safely
            $currentProgress = isset($habitArray['current_progress']) ? (float)$habitArray['current_progress'] : 0.0;
            $newProgress = $currentProgress + (float)$increment;
            $updateData['current_progress'] = $newProgress;
            
            // Check if target is reached
            $targetValue = isset($habitArray['target_value']) ? (float)$habitArray['target_value'] : 1.0;
            if ($newProgress >= $targetValue) {
                $updateData['is_completed'] = true;
                $updateData['completion_date'] = $currentTime;
            } else {
                // Ensure is_completed is false if target not reached
                $updateData['is_completed'] = false;
                $updateData['completion_date'] = null;
            }
        }
        
        $updateData['updated_at'] = $currentTime;
        
        // Perform update with better error handling
        $result = $collection->updateOne(
            ['_id' => new ObjectId($id)],
            ['$set' => $updateData]
        );
        
        if ($result->getMatchedCount() > 0) {
            // Return updated habit data
            $updatedHabit = $collection->findOne(['_id' => new ObjectId($id)]);
            
            if ($updatedHabit) {
                $habitData = [
                    '_id' => (string)$updatedHabit['_id'],
                    'title' => $updatedHabit['title'] ?? '',
                    'current_progress' => (float)($updatedHabit['current_progress'] ?? 0),
                    'target_value' => (float)($updatedHabit['target_value'] ?? 1),
                    'is_completed' => $updatedHabit['is_completed'] ?? false,
                    'completion_date' => $this->formatDate($updatedHabit['completion_date'] ?? null),
                    'updated_at' => $this->formatDate($updatedHabit['updated_at'] ?? null)
                ];
                
                return response()->json([
                    'status' => 200,
                    'message' => 'Progress updated successfully',
                    'data' => $habitData
                ], 200);
            }
        }
        
        // If we reach here, something went wrong
        return response()->json([
            'status' => 500,
            'message' => 'Failed to update progress'
        ], 500);
        
    } catch (\MongoDB\Exception\InvalidArgumentException $e) {
        Log::error('MongoDB Invalid Argument Error: ' . $e->getMessage());
        return response()->json([
            'status' => 400,
            'message' => 'Invalid data provided'
        ], 400);
    } catch (\MongoDB\Driver\Exception\Exception $e) {
        Log::error('MongoDB Driver Error: ' . $e->getMessage());
        return response()->json([
            'status' => 500,
            'message' => 'Database operation failed'
        ], 500);
    } catch (Exception $e) {
        Log::error('Error updating progress: ' . $e->getMessage());
        Log::error('Stack trace: ' . $e->getTraceAsString());
        return response()->json([
            'status' => 500,
            'message' => 'Error updating progress: ' . $e->getMessage()
        ], 500);
    }
}
 
    // MARK AS COMPLETED (CHECKLIST)
    public function markAsCompleted(string $id): JsonResponse {
        try {
            // Validasi ObjectId format
            if (!$this->isValidObjectId($id)) {
                return response()->json([
                    'status' => 400,
                    'message' => 'Invalid habit ID format'
                ], 400);
            }
            
            $collection = $this->db->selectCollection('targets');
            
            // Get habit first to check target_value
            $habit = $collection->findOne(['_id' => new ObjectId($id)]);
            if (!$habit) {
                return response()->json([
                    'status' => 404,
                    'message' => 'Habit not found'
                ], 404);
            }
            
            $currentTime = new UTCDateTime();
            $updateData = [
                'is_completed' => true,
                'completion_date' => $currentTime,
                'updated_at' => $currentTime,
                'current_progress' => (float)($habit['target_value'] ?? 1)
            ];
            
            $result = $collection->updateOne(
                ['_id' => new ObjectId($id)],
                ['$set' => $updateData]
            );
            
            if ($result->getModifiedCount() > 0) {
                return response()->json([
                    'status' => 200,
                    'message' => 'Habit marked as completed'
                ], 200);
            } else {
                return response()->json([
                    'status' => 500,
                    'message' => 'Failed to mark habit as completed'
                ], 500);
            }
            
        } catch (Exception $e) {
            Log::error('Error marking habit as completed: ' . $e->getMessage());
            return response()->json([
                'status' => 500,
                'message' => 'Error marking habit as completed: ' . $e->getMessage()
            ], 500);
        }
    }
    
    // UNMARK AS COMPLETED
    public function unmarkAsCompleted(string $id): JsonResponse {
        try {
            // Validasi ObjectId format
            if (!$this->isValidObjectId($id)) {
                return response()->json([
                    'status' => 400,
                    'message' => 'Invalid habit ID format'
                ], 400);
            }
            
            $collection = $this->db->selectCollection('targets');
            
            // Check if habit exists
            $habit = $collection->findOne(['_id' => new ObjectId($id)]);
            if (!$habit) {
                return response()->json([
                    'status' => 404,
                    'message' => 'Habit not found'
                ], 404);
            }
            
            $updateData = [
                'is_completed' => false,
                'completion_date' => null,
                'updated_at' => new UTCDateTime()
            ];
            
            $result = $collection->updateOne(
                ['_id' => new ObjectId($id)],
                ['$set' => $updateData]
            );
            
            if ($result->getModifiedCount() > 0) {
                return response()->json([
                    'status' => 200,
                    'message' => 'Habit unmarked as completed'
                ], 200);
            } else {
                return response()->json([
                    'status' => 500,
                    'message' => 'Failed to unmark habit'
                ], 500);
            }
            
        } catch (Exception $e) {
            Log::error('Error unmarking habit: ' . $e->getMessage());
            return response()->json([
                'status' => 500,
                'message' => 'Error unmarking habit: ' . $e->getMessage()
            ], 500);
        }
    }
    
    // GET HABITS BY CATEGORY
    public function getHabitsByCategory(string $category): JsonResponse {
        try {
            $collection = $this->db->selectCollection('targets');
            $cursor = $collection->find(['category' => $category]);
            
            $habits = [];
            foreach ($cursor as $document) {
                $habit = [
                    '_id' => (string)$document['_id'],
                    'title' => $document['title'] ?? '',
                    'description' => $document['description'] ?? '',
                    'category' => $document['category'] ?? 'regular_habit',
                    'target_type' => $document['target_type'] ?? 'daily',
                    'target_value' => $document['target_value'] ?? 1,
                    'current_progress' => $document['current_progress'] ?? 0,
                    'is_completed' => $document['is_completed'] ?? false,
                    'completion_date' => $this->formatDate($document['completion_date'] ?? null),
                    'created_at' => $this->formatDate($document['created_at'] ?? null),
                    'updated_at' => $this->formatDate($document['updated_at'] ?? null)
                ];
                $habits[] = $habit;
            }
            
            return response()->json([
                'status' => 200,
                'message' => 'Success',
                'data' => $habits
            ], 200);
            
        } catch (Exception $e) {
            Log::error('Error fetching habits by category: ' . $e->getMessage());
            return response()->json([
                'status' => 500,
                'message' => 'Error fetching habits by category: ' . $e->getMessage()
            ], 500);
        }
    }
    
    // GET COMPLETED HABITS
    public function getCompletedHabits(): JsonResponse {
        try {
            $collection = $this->db->selectCollection('targets');
            $cursor = $collection->find(['is_completed' => true]);
            
            $habits = [];
            foreach ($cursor as $document) {
                $habit = [
                    '_id' => (string)$document['_id'],
                    'title' => $document['title'] ?? '',
                    'description' => $document['description'] ?? '',
                    'category' => $document['category'] ?? 'regular_habit',
                    'target_type' => $document['target_type'] ?? 'daily',
                    'target_value' => $document['target_value'] ?? 1,
                    'current_progress' => $document['current_progress'] ?? 0,
                    'completion_date' => $this->formatDate($document['completion_date'] ?? null),
                    'created_at' => $this->formatDate($document['created_at'] ?? null),
                    'updated_at' => $this->formatDate($document['updated_at'] ?? null)
                ];
                $habits[] = $habit;
            }
            
            return response()->json([
                'status' => 200,
                'message' => 'Success',
                'data' => $habits
            ], 200);
            
        } catch (Exception $e) {
            Log::error('Error fetching completed habits: ' . $e->getMessage());
            return response()->json([
                'status' => 500,
                'message' => 'Error fetching completed habits: ' . $e->getMessage()
            ], 500);
        }
    }
    
    // RESET ALL HABITS (for testing or admin purposes)
    public function resetAllHabits(): JsonResponse {
        try {
            $collection = $this->db->selectCollection('targets');
            
            $currentTime = new UTCDateTime();
            
            $result = $collection->updateMany(
                [],
                ['$set' => [
                    'current_progress' => 0.0,
                    'is_completed' => false,
                    'completion_date' => null,
                    'last_reset_date' => $currentTime,
                    'updated_at' => $currentTime
                ]]
            );
            
            return response()->json([
                'status' => 200,
                'message' => 'All habits reset successfully',
                'data' => [
                    'modified_count' => $result->getModifiedCount()
                ]
            ], 200);
            
        } catch (Exception $e) {
            Log::error('Error resetting habits: ' . $e->getMessage());
            return response()->json([
                'status' => 500,
                'message' => 'Error resetting habits: ' . $e->getMessage()
            ], 500);
        }
    }
    
    // HELPER: Check if habit needs to be reset based on target_type - IMPROVED
    private function checkIfNeedsReset(array $habit): bool {
        try {
            $targetType = $habit['target_type'] ?? 'daily';
            $lastResetDate = $habit['last_reset_date'] ?? null;
            
            if (!$lastResetDate) {
                return false; // First time, no reset needed
            }
            
            // Handle different date formats more robustly
            $lastResetTimestamp = $this->parseDate($lastResetDate);
            if (!$lastResetTimestamp) {
                Log::warning('Could not parse last_reset_date, skipping reset check');
                return false;
            }
            
            $now = new DateTime();
            
            switch ($targetType) {
                case 'daily':
                    return $lastResetTimestamp->format('Y-m-d') < $now->format('Y-m-d');
                case 'weekly':
                    $weekStart = clone $now;
                    $weekStart->modify('monday this week')->setTime(0, 0, 0);
                    return $lastResetTimestamp < $weekStart;
                case 'monthly':
                    return $lastResetTimestamp->format('Y-m') < $now->format('Y-m');
                case 'yearly':
                    return $lastResetTimestamp->format('Y') < $now->format('Y');
                default:
                    return false;
            }
        } catch (Exception $e) {
            Log::error('Error in checkIfNeedsReset: ' . $e->getMessage());
            return false; // Default to no reset if there's an error
        }
    }
    
    // HELPER: Validate ObjectId format
    private function isValidObjectId(string $id): bool {
        return preg_match('/^[a-f\d]{24}$/i', $id) === 1;
    }
    
    // HELPER: Parse date from various formats
    private function parseDate($date): ?DateTime {
        if (!$date) {
            return null;
        }
        
        try {
            if ($date instanceof UTCDateTime) {
                return $date->toDateTime();
            } elseif ($date instanceof DateTime) {
                return $date;
            } elseif (is_string($date)) {
                return new DateTime($date);
            } elseif (is_object($date) && method_exists($date, 'toDateTime')) {
                return $date->toDateTime();
            }
        } catch (Exception $e) {
            Log::warning('Failed to parse date: ' . $e->getMessage());
        }
        
        return null;
    }
    
    // HELPER: Format date for API response
    private function formatDate($date): ?string {
        $parsedDate = $this->parseDate($date);
        return $parsedDate ? $parsedDate->format('Y-m-d H:i:s') : null;
    }
}