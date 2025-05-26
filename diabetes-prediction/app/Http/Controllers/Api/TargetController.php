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

            // Transform data untuk frontend
            $transformedHabits = $habits->map(function ($habit) {
                return [
                    '_id' => ['$oid' => (string) $habit->_id],
                    'title' => $habit->title,
                    'description' => $habit->description ?? null,
                    'category' => $habit->category,
                    'created_at' => isset($habit->created_at) ? ['$date' => $habit->created_at->toDateTime()->format('c')] : null,
                    'updated_at' => isset($habit->updated_at) ? ['$date' => $habit->updated_at->toDateTime()->format('c')] : null,
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

// Ganti method getActivitiesByDate di TargetController.php dengan ini:

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

        $activities = DB::connection('mongodb')
            ->table('activities')
            ->where('date', $date)
            ->get();

        Log::info("Ditemukan " . $activities->count() . " aktivitas untuk tanggal " . $date);

        // Transform data untuk frontend
        $transformedActivities = $activities->map(function ($activity) {
            return [
                '_id' => ['$oid' => (string) $activity->_id],
                'habitId' => (string) $activity->habitId,
                'date' => $activity->date,
                'isCompleted' => $activity->isCompleted ?? false,
                'created_at' => isset($activity->created_at) ? ['$date' => $activity->created_at->toDateTime()->format('c')] : null,
                'updated_at' => isset($activity->updated_at) ? ['$date' => $activity->updated_at->toDateTime()->format('c')] : null,
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $transformedActivities,
            'message' => 'Aktivitas berhasil diambil'
        ]);
    } catch (\Exception $e) {
        Log::error('Gagal mengambil aktivitas: ' . $e->getMessage() . "\n" . $e->getTraceAsString());
        return response()->json([
            'success' => false,
            'message' => 'Gagal mengambil aktivitas: ' . $e->getMessage()
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

            // Get the created habit to return
            $createdHabit = DB::connection('mongodb')
                ->table('targets')
                ->where('_id', $habitId)
                ->first();

            $transformedHabit = [
                '_id' => ['$oid' => (string) $createdHabit->_id],
                'title' => $createdHabit->title,
                'description' => $createdHabit->description ?? null,
                'category' => $createdHabit->category,
                'created_at' => ['$date' => $createdHabit->created_at->toDateTime()->format('c')],
                'updated_at' => ['$date' => $createdHabit->updated_at->toDateTime()->format('c')],
            ];

            return response()->json([
                'success' => true,
                'data' => $transformedHabit,
                'message' => 'Habit berhasil dibuat'
            ], 201);
        } catch (\Exception $e) {
            Log::error('Gagal membuat habit: ' . $e->getMessage() . "\n" . $e->getTraceAsString());
            return response()->json([
                'success' => false,
                'message' => 'Gagal membuat habit: ' . $e->getMessage()
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