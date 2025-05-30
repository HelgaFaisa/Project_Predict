<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use MongoDB\BSON\ObjectId;
use MongoDB\BSON\UTCDateTime;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class TargetController extends Controller
{
    public function getAllHabits()
    {
        try {
            $habits = DB::connection('mongodb')
                ->table('targets')
                ->where('category', 'regular_habit')
                ->orderBy('created_at', 'desc')
                ->get();

            // Transform data untuk frontend dengan pengecekan property
            $transformedHabits = $habits->map(function ($habit) {
                // Convert stdClass to array untuk akses yang lebih aman
                $habitArray = json_decode(json_encode($habit), true);
                
                return [
                    '_id' => ['$oid' => isset($habitArray['_id']) ? (string) $habitArray['_id'] : ''],
                    'title' => $habitArray['title'] ?? '',
                    'description' => $habitArray['description'] ?? null,
                    'category' => $habitArray['category'] ?? 'regular_habit',
                    'created_at' => isset($habitArray['created_at']) && $habitArray['created_at'] 
                        ? ['$date' => $habitArray['created_at']] 
                        : null,
                    'updated_at' => isset($habitArray['updated_at']) && $habitArray['updated_at'] 
                        ? ['$date' => $habitArray['updated_at']] 
                        : null,
                ];
            });

            return response()->json([
                'success' => true,
                'data' => $transformedHabits,
                'message' => 'Habit berhasil diambil'
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil habit: ' . $e->getMessage() . "\n" . $e->getTraceAsString());
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil habit: ' . $e->getMessage()
            ], 500);
        }
    }

    public function createHabit(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'title' => 'required|string|max:255',
                'description' => 'nullable|string|max:1000',
                'category' => 'nullable|string|max:100'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Data tidak valid',
                    'errors' => $validator->errors()
                ], 422);
            }

            $habitData = [
                'title' => $request->title,
                'description' => $request->description,
                'category' => $request->category ?? 'regular_habit',
                'created_at' => new UTCDateTime(),
                'updated_at' => new UTCDateTime()
            ];

            $habitId = DB::connection('mongodb')
                ->table('targets')
                ->insertGetId($habitData);

            // **TAMBAHAN: Buat activity untuk hari ini secara otomatis**
            $today = Carbon::today()->format('Y-m-d');
            $activityData = [
                'habitId' => (string) $habitId,
                'date' => $today,
                'isCompleted' => false,
                'created_at' => new UTCDateTime(),
                'updated_at' => new UTCDateTime()
            ];

            DB::connection('mongodb')
                ->table('activities')
                ->insert($activityData);

            Log::info("Activity created for habit " . $habitId . " on date " . $today);

            // Get the created habit to return
            $createdHabit = DB::connection('mongodb')
                ->table('targets')
                ->where('_id', $habitId)
                ->first();

            // Convert to array untuk akses yang aman
            $habitArray = json_decode(json_encode($createdHabit), true);

            $transformedHabit = [
                '_id' => ['$oid' => isset($habitArray['_id']) ? (string) $habitArray['_id'] : (string) $habitId],
                'title' => $habitArray['title'] ?? '',
                'description' => $habitArray['description'] ?? null,
                'category' => $habitArray['category'] ?? 'regular_habit',
                'created_at' => isset($habitArray['created_at']) 
                    ? ['$date' => $habitArray['created_at']] 
                    : null,
                'updated_at' => isset($habitArray['updated_at']) 
                    ? ['$date' => $habitArray['updated_at']] 
                    : null,
            ];

            return response()->json([
                'success' => true,
                'data' => $transformedHabit,
                'message' => 'Habit berhasil dibuat dan activity hari ini telah ditambahkan'
            ], 201);
        } catch (\Exception $e) {
            Log::error('Gagal membuat habit: ' . $e->getMessage() . "\n" . $e->getTraceAsString());
            return response()->json([
                'success' => false,
                'message' => 'Gagal membuat habit: ' . $e->getMessage()
            ], 500);
        }
    }

    public function generateDailyActivities($date = null)
    {
        try {
            $targetDate = $date ?? Carbon::today()->format('Y-m-d');
            
            Log::info("Generating daily activities for date: " . $targetDate);

            // Get all active habits
            $habits = DB::connection('mongodb')
                ->table('targets')
                ->where('category', 'regular_habit')
                ->get();

            $createdCount = 0;

            foreach ($habits as $habit) {
                // Check if activity already exists for this date
                $existingActivity = DB::connection('mongodb')
                    ->table('activities')
                    ->where('habitId', (string) $habit->_id)
                    ->where('date', $targetDate)
                    ->first();

                if (!$existingActivity) {
                    // Create new activity
                    $activityData = [
                        'habitId' => (string) $habit->_id,
                        'date' => $targetDate,
                        'isCompleted' => false,
                        'created_at' => new UTCDateTime(),
                        'updated_at' => new UTCDateTime()
                    ];

                    DB::connection('mongodb')
                        ->table('activities')
                        ->insert($activityData);

                    $createdCount++;
                    Log::info("Created activity for habit: " . $habit->title . " on " . $targetDate);
                }
            }

            return response()->json([
                'success' => true,
                'message' => "Generated {$createdCount} activities for {$targetDate}",
                'data' => [
                    'date' => $targetDate,
                    'created_count' => $createdCount,
                    'total_habits' => $habits->count()
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Gagal generate daily activities: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Gagal generate daily activities: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getHabitsWithTodayStatus($date = null)
{
    try {
        $targetDate = $date ?? Carbon::today()->format('Y-m-d');
        
        Log::info("Getting habits with status for date: " . $targetDate);

        // Get habits dengan join ke activities
        $habits = DB::connection('mongodb')
            ->table('targets')
            ->where('category', 'regular_habit')
            ->get();

        // Auto-generate activities untuk tanggal ini jika belum ada
        foreach ($habits as $habit) {
            // Convert habit to array untuk akses yang aman
            $habitArray = json_decode(json_encode($habit), true);
            $habitId = isset($habitArray['_id']) ? (string) $habitArray['_id'] : '';
            
            if ($habitId) {
                $existingActivity = DB::connection('mongodb')
                    ->table('activities')
                    ->where('habitId', $habitId)
                    ->where('date', $targetDate)
                    ->first();

                if (!$existingActivity) {
                    DB::connection('mongodb')
                        ->table('activities')
                        ->insert([
                            'habitId' => $habitId,
                            'date' => $targetDate,
                            'isCompleted' => false,
                            'created_at' => new UTCDateTime(),
                            'updated_at' => new UTCDateTime()
                        ]);
                }
            }
        }

        // Get habits dengan status completion
        $habitsWithStatus = $habits->map(function ($habit) use ($targetDate) {
            // Convert to array untuk akses yang aman
            $habitArray = json_decode(json_encode($habit), true);
            $habitId = isset($habitArray['_id']) ? (string) $habitArray['_id'] : '';
            
            // Get activity for this date
            $activity = null;
            if ($habitId) {
                $activity = DB::connection('mongodb')
                    ->table('activities')
                    ->where('habitId', $habitId)
                    ->where('date', $targetDate)
                    ->first();
            }

            return [
                '_id' => ['$oid' => $habitId],
                'habitId' => $habitId,
                'title' => $habitArray['title'] ?? '',
                'description' => $habitArray['description'] ?? null,
                'category' => $habitArray['category'] ?? 'regular_habit',
                'date' => $targetDate,
                'isCompleted' => $activity ? $activity->isCompleted : false,
                'activityId' => $activity ? (string) $activity->_id : null,
                'created_at' => isset($habitArray['created_at']) && $habitArray['created_at']
                    ? ['$date' => $habitArray['created_at']] 
                    : null,
                'updated_at' => isset($habitArray['updated_at']) && $habitArray['updated_at']
                    ? ['$date' => $habitArray['updated_at']] 
                    : null,
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $habitsWithStatus,
            'message' => 'Habits dengan status berhasil diambil'
        ]);

    } catch (\Exception $e) {
        Log::error('Gagal mengambil habits dengan status: ' . $e->getMessage());
        return response()->json([
            'success' => false,
            'message' => 'Gagal mengambil habits dengan status: ' . $e->getMessage()
        ], 500);
    }
}

    public function getActivitiesByDate($date)
    {
        try {
            // Validasi format tanggal
            if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $date)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Format tanggal tidak valid. Gunakan format YYYY-MM-DD'
                ], 400);
            }

            // Validasi apakah tanggal valid
            $dateObj = \DateTime::createFromFormat('Y-m-d', $date);
            if (!$dateObj || $dateObj->format('Y-m-d') !== $date) {
                return response()->json([
                    'success' => false,
                    'message' => 'Tanggal tidak valid'
                ], 400);
            }

            Log::info("Mengambil aktivitas untuk tanggal: " . $date);

            // Generate activities untuk tanggal ini jika belum ada
            $this->generateDailyActivities($date);

            $activities = DB::connection('mongodb')
                ->table('activities')
                ->where('date', $date)
                ->get();

            Log::info("Ditemukan " . $activities->count() . " activities untuk tanggal " . $date);

            // Transform data untuk frontend
            $transformedActivities = $activities->map(function ($activity) {
                // Get habit info
                $habit = DB::connection('mongodb')
                    ->table('targets')
                    ->where('_id', new ObjectId($activity->habitId))
                    ->first();

                return [
                    '_id' => ['$oid' => (string) $activity->_id],
                    'habitId' => (string) $activity->habitId,
                    'habitTitle' => $habit ? $habit->title : 'Unknown Habit',
                    'habitDescription' => $habit ? ($habit->description ?? null) : null,
                    'date' => $activity->date,
                    'isCompleted' => $activity->isCompleted ?? false,
                    'created_at' => isset($activity->created_at) ? ['$date' => $activity->created_at->toDateTime()->format('c')] : null,
                    'updated_at' => isset($activity->updated_at) ? ['$date' => $activity->updated_at->toDateTime()->format('c')] : null,
                ];
            });

            return response()->json([
                'success' => true,
                'data' => $transformedActivities,
                'message' => 'Activities berhasil diambil'
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil activities: ' . $e->getMessage() . "\n" . $e->getTraceAsString());
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil activities: ' . $e->getMessage()
            ], 500);
        }
    }

    public function updateHabit(Request $request, $id)
    {
        try {
            // Validasi ObjectId
            if (!preg_match('/^[a-f\d]{24}$/i', $id)) {
                return response()->json([
                    'success' => false,
                    'message' => 'ID habit tidak valid'
                ], 400);
            }

            $validator = Validator::make($request->all(), [
                'title' => 'required|string|max:255',
                'description' => 'nullable|string|max:1000',
                'category' => 'nullable|string|max:100'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Data tidak valid',
                    'errors' => $validator->errors()
                ], 422);
            }

            // Cek apakah habit exists
            $existingHabit = DB::connection('mongodb')
                ->table('targets')
                ->where('_id', new ObjectId($id))
                ->first();

            if (!$existingHabit) {
                return response()->json([
                    'success' => false,
                    'message' => 'Habit tidak ditemukan'
                ], 404);
            }

            $updateData = [
                'title' => $request->title,
                'description' => $request->description,
                'category' => $request->category ?? 'regular_habit',
                'updated_at' => new UTCDateTime()
            ];

            DB::connection('mongodb')
                ->table('targets')
                ->where('_id', new ObjectId($id))
                ->update($updateData);

            // Get updated habit
            $updatedHabit = DB::connection('mongodb')
                ->table('targets')
                ->where('_id', new ObjectId($id))
                ->first();

            $transformedHabit = [
                '_id' => ['$oid' => (string) $updatedHabit->_id],
                'title' => $updatedHabit->title,
                'description' => $updatedHabit->description ?? null,
                'category' => $updatedHabit->category,
                'created_at' => isset($updatedHabit->created_at) ? ['$date' => $updatedHabit->created_at->toDateTime()->format('c')] : null,
                'updated_at' => ['$date' => $updatedHabit->updated_at->toDateTime()->format('c')],
            ];

            return response()->json([
                'success' => true,
                'data' => $transformedHabit,
                'message' => 'Habit berhasil diperbarui'
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal memperbarui habit: ' . $e->getMessage() . "\n" . $e->getTraceAsString());
            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui habit: ' . $e->getMessage()
            ], 500);
        }
    }

    public function deleteHabit($id)
    {
        try {
            // Validasi ObjectId
            if (!preg_match('/^[a-f\d]{24}$/i', $id)) {
                return response()->json([
                    'success' => false,
                    'message' => 'ID habit tidak valid'
                ], 400);
            }

            // Cek apakah habit exists
            $existingHabit = DB::connection('mongodb')
                ->table('targets')
                ->where('_id', new ObjectId($id))
                ->first();

            if (!$existingHabit) {
                return response()->json([
                    'success' => false,
                    'message' => 'Habit tidak ditemukan'
                ], 404);
            }

            // Delete habit
            DB::connection('mongodb')
                ->table('targets')
                ->where('_id', new ObjectId($id))
                ->delete();

            // Delete related activities
            DB::connection('mongodb')
                ->table('activities')
                ->where('habitId', $id)
                ->delete();

            return response()->json([
                'success' => true,
                'message' => 'Habit dan aktivitas terkait berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal menghapus habit: ' . $e->getMessage() . "\n" . $e->getTraceAsString());
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus habit: ' . $e->getMessage()
            ], 500);
        }
    }

    public function createOrUpdateActivity(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'habitId' => 'required|string',
                'date' => 'required|date_format:Y-m-d',
                'isCompleted' => 'required|boolean'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Data tidak valid',
                    'errors' => $validator->errors()
                ], 422);
            }

            // Validasi habitId
            if (!preg_match('/^[a-f\d]{24}$/i', $request->habitId)) {
                return response()->json([
                    'success' => false,
                    'message' => 'ID habit tidak valid'
                ], 400);
            }

            // Cek apakah habit exists
            $habit = DB::connection('mongodb')
                ->table('targets')
                ->where('_id', new ObjectId($request->habitId))
                ->first();

            if (!$habit) {
                return response()->json([
                    'success' => false,
                    'message' => 'Habit tidak ditemukan'
                ], 404);
            }

            // Cek apakah activity sudah ada
            $existingActivity = DB::connection('mongodb')
                ->table('activities')
                ->where('habitId', $request->habitId)
                ->where('date', $request->date)
                ->first();

            if ($existingActivity) {
                // Update existing activity
                DB::connection('mongodb')
                    ->table('activities')
                    ->where('_id', $existingActivity->_id)
                    ->update([
                        'isCompleted' => $request->isCompleted,
                        'updated_at' => new UTCDateTime()
                    ]);

                $updatedActivity = DB::connection('mongodb')
                    ->table('activities')
                    ->where('_id', $existingActivity->_id)
                    ->first();

                $transformedActivity = [
                    '_id' => ['$oid' => (string) $updatedActivity->_id],
                    'habitId' => (string) $updatedActivity->habitId,
                    'date' => $updatedActivity->date,
                    'isCompleted' => $updatedActivity->isCompleted,
                    'created_at' => isset($updatedActivity->created_at) ? ['$date' => $updatedActivity->created_at->toDateTime()->format('c')] : null,
                    'updated_at' => ['$date' => $updatedActivity->updated_at->toDateTime()->format('c')],
                ];

                return response()->json([
                    'success' => true,
                    'data' => $transformedActivity,
                    'message' => 'Aktivitas berhasil diperbarui'
                ]);
            } else {
                // Create new activity
                $activityData = [
                    'habitId' => $request->habitId,
                    'date' => $request->date,
                    'isCompleted' => $request->isCompleted,
                    'created_at' => new UTCDateTime(),
                    'updated_at' => new UTCDateTime()
                ];

                $activityId = DB::connection('mongodb')
                    ->table('activities')
                    ->insertGetId($activityData);

                $createdActivity = DB::connection('mongodb')
                    ->table('activities')
                    ->where('_id', $activityId)
                    ->first();

                $transformedActivity = [
                    '_id' => ['$oid' => (string) $createdActivity->_id],
                    'habitId' => (string) $createdActivity->habitId,
                    'date' => $createdActivity->date,
                    'isCompleted' => $createdActivity->isCompleted,
                    'created_at' => ['$date' => $createdActivity->created_at->toDateTime()->format('c')],
                    'updated_at' => ['$date' => $createdActivity->updated_at->toDateTime()->format('c')],
                ];

                return response()->json([
                    'success' => true,
                    'data' => $transformedActivity,
                    'message' => 'Aktivitas berhasil dibuat'
                ], 201);
            }
        } catch (\Exception $e) {
            Log::error('Gagal membuat/memperbarui aktivitas: ' . $e->getMessage() . "\n" . $e->getTraceAsString());
            return response()->json([
                'success' => false,
                'message' => 'Gagal membuat/memperbarui aktivitas: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getHabitById($id)
    {
        try {
            // Validasi ObjectId
            if (!preg_match('/^[a-f\d]{24}$/i', $id)) {
                return response()->json([
                    'success' => false,
                    'message' => 'ID habit tidak valid'
                ], 400);
            }

            $habit = DB::connection('mongodb')
                ->table('targets')
                ->where('_id', new ObjectId($id))
                ->first();

            if (!$habit) {
                return response()->json([
                    'success' => false,
                    'message' => 'Habit tidak ditemukan'
                ], 404);
            }

            $transformedHabit = [
                '_id' => ['$oid' => (string) $habit->_id],
                'title' => $habit->title,
                'description' => $habit->description ?? null,
                'category' => $habit->category,
                'created_at' => isset($habit->created_at) ? ['$date' => $habit->created_at->toDateTime()->format('c')] : null,
                'updated_at' => isset($habit->updated_at) ? ['$date' => $habit->updated_at->toDateTime()->format('c')] : null,
            ];

            return response()->json([
                'success' => true,
                'data' => $transformedHabit,
                'message' => 'Habit berhasil diambil'
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil habit: ' . $e->getMessage() . "\n" . $e->getTraceAsString());
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil habit: ' . $e->getMessage()
            ], 500);
        }
    }

    public function deleteActivity($id)
    {
        try {
            // Validasi ObjectId
            if (!preg_match('/^[a-f\d]{24}$/i', $id)) {
                return response()->json([
                    'success' => false,
                    'message' => 'ID aktivitas tidak valid'
                ], 400);
            }

            // Cek apakah activity exists
            $existingActivity = DB::connection('mongodb')
                ->table('activities')
                ->where('_id', new ObjectId($id))
                ->first();

            if (!$existingActivity) {
                return response()->json([
                    'success' => false,
                    'message' => 'Aktivitas tidak ditemukan'
                ], 404);
            }

            // Delete activity
            DB::connection('mongodb')
                ->table('activities')
                ->where('_id', new ObjectId($id))
                ->delete();

            return response()->json([
                'success' => true,
                'message' => 'Aktivitas berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal menghapus aktivitas: ' . $e->getMessage() . "\n" . $e->getTraceAsString());
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus aktivitas: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getHabitStats($id)
    {
        try {
            // Validasi ObjectId
            if (!preg_match('/^[a-f\d]{24}$/i', $id)) {
                return response()->json([
                    'success' => false,
                    'message' => 'ID habit tidak valid'
                ], 400);
            }

            // Cek apakah habit exists
            $habit = DB::connection('mongodb')
                ->table('targets')
                ->where('_id', new ObjectId($id))
                ->first();

            if (!$habit) {
                return response()->json([
                    'success' => false,
                    'message' => 'Habit tidak ditemukan'
                ], 404);
            }

            // Get all activities for this habit
            $activities = DB::connection('mongodb')
                ->table('activities')
                ->where('habitId', $id)
                ->get();

            $totalActivities = $activities->count();
            $completedActivities = $activities->where('isCompleted', true)->count();
            $completionRate = $totalActivities > 0 ? ($completedActivities / $totalActivities) * 100 : 0;

            // Get current streak
            $currentStreak = $this->calculateCurrentStreak($id);

            // Get longest streak
            $longestStreak = $this->calculateLongestStreak($id);

            $stats = [
                'habitId' => $id,
                'totalActivities' => $totalActivities,
                'completedActivities' => $completedActivities,
                'completionRate' => round($completionRate, 2),
                'currentStreak' => $currentStreak,
                'longestStreak' => $longestStreak
            ];

            return response()->json([
                'success' => true,
                'data' => $stats,
                'message' => 'Statistik habit berhasil diambil'
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal mengambil statistik habit: ' . $e->getMessage() . "\n" . $e->getTraceAsString());
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil statistik habit: ' . $e->getMessage()
            ], 500);
        }
    }

    private function calculateCurrentStreak($habitId)
    {
        $activities = DB::connection('mongodb')
            ->table('activities')
            ->where('habitId', $habitId)
            ->where('isCompleted', true)
            ->orderBy('date', 'desc')
            ->get();

        if ($activities->isEmpty()) {
            return 0;
        }

        $streak = 0;
        $yesterday = Carbon::yesterday()->format('Y-m-d');
        $today = Carbon::today()->format('Y-m-d');

        foreach ($activities as $activity) {
            if ($activity->date == $today || $activity->date == $yesterday) {
                $streak++;
                $yesterday = Carbon::parse($activity->date)->subDay()->format('Y-m-d');
            } else {
                break;
            }
        }

        return $streak;
    }

    private function calculateLongestStreak($habitId)
    {
        $activities = DB::connection('mongodb')
            ->table('activities')
            ->where('habitId', $habitId)
            ->where('isCompleted', true)
            ->orderBy('date', 'asc')
            ->pluck('date')
            ->toArray();

        if (empty($activities)) {
            return 0;
        }

        $longestStreak = 1;
        $currentStreak = 1;

        for ($i = 1; $i < count($activities); $i++) {
            $currentDate = Carbon::parse($activities[$i]);
            $previousDate = Carbon::parse($activities[$i - 1]);

            if ($currentDate->diffInDays($previousDate) == 1) {
                $currentStreak++;
                $longestStreak = max($longestStreak, $currentStreak);
            } else {
                $currentStreak = 1;
            }
        }

        return $longestStreak;
    }
}