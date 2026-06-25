<!DOCTYPE html>
<html>
<head>
    <title>Data Resep</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f1f8e9;
        }

        .sidebar {
            width: 250px;
            height: 100vh;
            background: #2e7d32;
            position: fixed;
            left: 0;
            top: 0;
            color: white;
            padding: 20px;
        }

        .sidebar h2 {
            text-align: center;
            margin-bottom: 30px;
        }

        .sidebar a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .sidebar a:hover,
        .sidebar .active {
            background: #1b5e20;
        }

        .logout {
            margin-top: 30px;
            background: #c62828;
            text-align: center;
        }

        .logout:hover {
            background: #b71c1c;
        }

        .content {
            margin-left: 250px;
            padding: 30px;
        }

        .header,
        .table-box {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }

        .header h1 {
            color: #2e7d32;
        }

        .header p {
            color: #555;
            margin-top: 8px;
        }

        .btn {
            display: inline-block;
            background: #2e7d32;
            color: white;
            padding: 10px 15px;
            border-radius: 8px;
            text-decoration: none;
            margin-bottom: 15px;
        }

        .btn:hover {
            background: #1b5e20;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #2e7d32;
            color: white;
            padding: 12px;
            text-align: left;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            vertical-align: top;
        }

        tr:hover {
            background: #f1f8e9;
        }

        img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 8px;
        }

        .btn-delete {
            background: #c62828;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
        }

        .btn-delete:hover {
            background: #b71c1c;
        }

        .success {
            background: #dcfce7;
            color: #166534;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .empty {
            text-align: center;
            color: #777;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>🌿 Diabetes Admin</h2>

    <a href="/admin/dashboard">🏠 Beranda</a>
    <a href="/admin/pengguna">👤 Data Pengguna</a>
    <a href="/admin/gula-darah">📊 Data Gula Darah</a>
    <a href="/admin/food-items">🥤 Makanan Dan Minuman</a>
    <a href="/admin/reseps" class="active">🍳 Resep</a>

    <a href="/admin/logout" class="logout">🚪 Logout</a>
</div>

<div class="content">

    <div class="header">
        <h1>Data Resep</h1>
        <p>Kelola resep makanan sehat untuk pengguna diabetes.</p>
    </div>

    <div class="table-box">
        <a href="/admin/reseps/create" class="btn">+ Tambah Resep</a>

        @if(session('success'))
            <div class="success">{{ session('success') }}</div>
        @endif

        <table>
            <thead>
                <tr>
                    <th>No</th>
                    <th>Gambar</th>
                    <th>Nama</th>
                    <th>Komposisi</th>
                    <th>Cara</th>
                    <th>Aksi</th>
                </tr>
            </thead>

            <tbody>
                @forelse($reseps as $resep)
                    <tr>
                        <td>{{ $loop->iteration }}</td>
                        <td>
                            @if($resep->gambar)
                                <img src="{{ asset($resep->gambar) }}">
                            @else
                                -
                            @endif
                        </td>
                        <td>{{ $resep->nama }}</td>
                        <td>{{ $resep->komposisi }}</td>
                        <td>{{ $resep->cara }}</td>
                        <td>
                            <form action="/admin/reseps/{{ $resep->id }}" method="POST">
                                @csrf
                                @method('DELETE')
                                <button class="btn-delete" onclick="return confirm('Hapus resep ini?')">
                                    Hapus
                                </button>
                            </form>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="6" class="empty">Belum ada data resep</td>
                    </tr>
                @endforelse
            </tbody>
        </table>

        <br>
        {{ $reseps->links() }}
    </div>

</div>

</body>
</html>