@csrf
<div class="space-y-4">
    <div>
        <label for="patient_id" class="block text-sm font-medium text-gray-700 mb-1">Pilih Pasien <span class="text-red-500">*</span></label>
        <select name="patient_id" id="patient_id" required {{ isset($account) ? 'disabled' : '' }}
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('patient_id') border-red-500 @enderror {{ isset($account) ? 'bg-gray-100 cursor-not-allowed' : '' }}">
            <option value="">-- Pilih Pasien --</option>
            @foreach ($patients as $patient)
                <option value="{{ $patient->_id }}" 
                        {{ old('patient_id', $account->patient_id ?? '') == $patient->_id ? 'selected' : '' }}>
                    {{ $patient->name }} (ID: {{ $patient->_id }})
                </option>
            @endforeach
        </select>
        @if(isset($account))
            <input type="hidden" name="patient_id" value="{{ $account->patient_id }}">
            <p class="text-xs text-gray-500 mt-1">Pasien tidak dapat diubah setelah akun dibuat.</p>
        @endif
        @error('patient_id') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
    </div>
    
    {{-- Nama akan diambil dari data pasien, tapi bisa ditampilkan di sini --}}
    @if(isset($account))
    <div>
        <label for="name_display" class="block text-sm font-medium text-gray-700 mb-1">Nama Pasien (Otomatis)</label>
        <input type="text" id="name_display" value="{{ old('name', $account->name ?? '') }}" readonly
               class="w-full px-4 py-2 border border-gray-300 rounded-lg bg-gray-100">
        <input type="hidden" name="name" value="{{ old('name', $account->name ?? '') }}">
    </div>
    @else
     <div>
        <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Nama Pasien (akan terisi otomatis) <span class="text-red-500">*</span></label>
        <input type="text" name="name" id="name" value="{{ old('name', $account->name ?? '') }}" required readonly
               class="w-full px-4 py-2 border border-gray-300 rounded-lg bg-gray-100 @error('name') border-red-500 @enderror">
        @error('name') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
    </div>
    @endif


    <div>
        <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email Login <span class="text-red-500">*</span></label>
        <input type="email" name="email" id="email" value="{{ old('email', $account->email ?? '') }}" required
               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('email') border-red-500 @enderror">
        @error('email') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
    </div>

    <div>
        <label for="phone_number" class="block text-sm font-medium text-gray-700 mb-1">Nomor Telepon (Opsional)</label>
        <input type="tel" name="phone_number" id="phone_number" value="{{ old('phone_number', $account->phone_number ?? '') }}"
               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('phone_number') border-red-500 @enderror">
        @error('phone_number') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
    </div>

    <div>
        <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password <span class="text-red-500">{{ isset($account) ? '' : '*' }}</span></label>
        <input type="password" name="password" id="password" {{ isset($account) ? '' : 'required' }}
               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('password') border-red-500 @enderror">
        @if(isset($account)) <p class="text-xs text-gray-500 mt-1">Kosongkan jika tidak ingin mengubah password.</p> @endif
        @error('password') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
    </div>

    <div>
        <label for="password_confirmation" class="block text-sm font-medium text-gray-700 mb-1">Konfirmasi Password <span class="text-red-500">{{ isset($account) ? '' : '*' }}</span></label>
        <input type="password" name="password_confirmation" id="password_confirmation" {{ isset($account) ? '' : 'required' }}
               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500">
    </div>
    
    <div>
        <label for="status" class="block text-sm font-medium text-gray-700 mb-1">Status Akun <span class="text-red-500">*</span></label>
        <select name="status" id="status" required
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('status') border-red-500 @enderror">
            <option value="active" {{ old('status', $account->status ?? 'active') == 'active' ? 'selected' : '' }}>Aktif</option>
            <option value="inactive" {{ old('status', $account->status ?? '') == 'inactive' ? 'selected' : '' }}>Tidak Aktif</option>
        </select>
        @error('status') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
    </div>

</div>

<div class="flex items-center space-x-4 pt-6 border-t border-gray-200 mt-6">
    <button type="submit"
            class="inline-flex items-center px-6 py-2 bg-indigo-600 border border-transparent rounded-md font-semibold text-sm text-white uppercase tracking-widest hover:bg-indigo-700 active:bg-indigo-800 focus:outline-none focus:border-indigo-900 focus:ring focus:ring-indigo-300 disabled:opacity-25 transition">
        <i class="ri-save-line mr-2 -ml-1"></i>
        {{ isset($account) ? 'Simpan Perubahan' : 'Buat Akun' }}
    </button>
    <a href="{{ route('admin.patient_accounts.index') }}"
       class="inline-flex items-center px-4 py-2 bg-white border border-gray-300 rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-25 transition">
        Batal
    </a>
</div>

@push('scripts')
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const patientSelect = document.getElementById('patient_id');
        const nameInput = document.getElementById('name'); // Input nama yang readonly

        if (patientSelect && nameInput && !nameInput.value) { // Hanya set jika nama belum ada (misal dari old input)
            patientSelect.addEventListener('change', function() {
                const selectedOption = this.options[this.selectedIndex];
                if (selectedOption && selectedOption.value) {
                    // Ekstrak nama dari teks option, hilangkan bagian (ID: ...)
                    const patientName = selectedOption.text.split(' (ID:')[0];
                    nameInput.value = patientName;
                } else {
                    nameInput.value = '';
                }
            });
            // Trigger change saat load jika ada value terpilih untuk mengisi nama
            if(patientSelect.value){
                 const event = new Event('change');
                 patientSelect.dispatchEvent(event);
            }
        }
    });
</script>
@endpush
