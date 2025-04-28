@extends('layouts.app')

@section('content')
<div class="main-content">
    <h2 class="page-title">Kelola Gejala Diagnosis</h2>

    <!-- Form Tambah/Update -->
    <div class="form-card">
        <form id="formGejala" class="form-gejala">
            <input type="hidden" name="id" id="gejalaId">
            <input type="text" name="name" id="name" placeholder="Nama Gejala" required>
            <input type="number" name="weight" id="weight" step="0.1" placeholder="Bobot" required>
            <button type="submit" id="submitBtn" class="btn-submit">Tambah Gejala</button>
        </form>
    </div>

    <!-- Daftar Gejala -->
    <div class="form-card" style="margin-top: 20px;">
        <div class="table-responsive">
            <table class="table-gejala">
                <thead>
                    <tr>
                        <th>Nama</th>
                        <th>Bobot</th>
                        <th>Status</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody id="listGejala">
                    <!-- Diisi lewat JS -->
                </tbody>
            </table>
        </div>
    </div>

    <script>
        const apiUrl = "/api/gejala";

        // Ambil data gejala
        async function fetchGejala() {
            const res = await fetch(apiUrl);
            const data = await res.json();
            
            const tbody = document.getElementById('listGejala');
            tbody.innerHTML = "";
            
            data.forEach(g => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${g.name}</td>
                    <td>${g.weight}</td>
                    <td><span class="badge ${g.active ? 'badge-active' : 'badge-inactive'}">${g.active ? 'Aktif' : 'Nonaktif'}</span></td>
                    <td>
                        <button class="btn-action btn-edit" onclick="editGejala('${g._id}', '${g.name}', ${g.weight})">Edit</button>
                        <button class="btn-action ${g.active ? 'btn-delete' : 'btn-toggle'}" onclick="toggleAktif('${g._id}', ${g.active})">${g.active ? 'Nonaktifkan' : 'Aktifkan'}</button>
                        <button class="btn-action btn-delete" onclick="hapusGejala('${g._id}')">Hapus</button>
                    </td>
                `;
                tbody.appendChild(row);
            });
        }

        // Tambah atau update gejala
        document.getElementById('formGejala').addEventListener('submit', async function(e) {
            e.preventDefault();
            const id = document.getElementById('gejalaId').value;
            const payload = {
                name: document.getElementById('name').value,
                weight: parseFloat(document.getElementById('weight').value)
            };
            
            if (id) {
                await fetch(`${apiUrl}/${id}`, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });
                document.getElementById('submitBtn').innerText = 'Tambah Gejala';
            } else {
                await fetch(apiUrl, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });
            }
            
            document.getElementById('formGejala').reset();
            document.getElementById('gejalaId').value = '';
            fetchGejala();
        });

        // Isi form untuk edit
        function editGejala(id, name, weight) {
            document.getElementById('gejalaId').value = id;
            document.getElementById('name').value = name;
            document.getElementById('weight').value = weight;
            document.getElementById('submitBtn').innerText = 'Simpan Perubahan';
        }

        // Hapus gejala
        async function hapusGejala(id) {
            if(confirm('Apakah Anda yakin ingin menghapus gejala ini?')) {
                await fetch(`${apiUrl}/${id}`, { method: 'DELETE' });
                fetchGejala();
            }
        }

        // Aktif/nonaktif gejala
        async function toggleAktif(id, current) {
            await fetch(`${apiUrl}/${id}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ active: !current })
            });
            fetchGejala();
        }

        // Load data saat halaman dimuat
        fetchGejala();
    </script>
</div>
@endsection