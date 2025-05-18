@if (session('success'))
    <div x-data="{ show: true }"
         x-init="setTimeout(() => show = false, 3000)" {{-- Alert sukses hilang setelah 3 detik --}}
         x-show="show"
         x-transition:leave="transition ease-in duration-300"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0"
         class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-4 rounded-md"
         role="alert">
        <p class="font-bold">Sukses!</p>
        <p>{{ session('success') }}</p>
    </div>
@endif

@if (session('error'))
    <div x-data="{ show: true }"
         x-init="setTimeout(() => show = false, 5000)" {{-- Alert error hilang setelah 5 detik --}}
         x-show="show"
         x-transition:leave="transition ease-in duration-300"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0"
         class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-4 rounded-md"
         role="alert">
        <p class="font-bold">Error!</p>
        <p>{{ session('error') }}</p>
    </div>
@endif

{{-- Ini bisa digunakan di form jika Anda tidak ingin menampilkan $errors->all() secara umum --}}
{{-- Jika Anda mengaktifkan blok ini, pertimbangkan durasi yang lebih lama atau apakah auto-dismiss cocok untuk error validasi --}}
{{-- @if ($errors->any() && !isset($hideCommonErrors))
    <div x-data="{ show: true }"
         x-init="setTimeout(() => show = false, 7000)" --}}{{-- Error validasi hilang setelah 7 detik (sesuaikan jika perlu) --}}{{--
         x-show="show"
         x-transition:leave="transition ease-in duration-300"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0"
         class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-md"
         role="alert">
        <p class="font-bold">Terdapat beberapa kesalahan input:</p>
        <ul class="mt-2 list-disc list-inside text-sm">
            @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif --}}