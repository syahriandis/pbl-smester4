<!DOCTYPE html>
<html>

<head>
    <title>Food Items</title>

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
            box-shadow: 0 3px 10px rgba(0, 0, 0, .1);
            margin-bottom: 25px;
        }

        .header h1 {
            color: #2e7d32;
        }

        .header p {
            margin-top: 8px;
            color: #666;
        }

        .btn {
            display: inline-block;
            background: #2e7d32;
            color: white;
            text-decoration: none;
            padding: 10px 18px;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .btn:hover {
            background: #1b5e20;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table th {
            background: #2e7d32;
            color: white;
            padding: 12px;
        }

        table td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: center;
            vertical-align: middle;
        }

        tr:hover {
            background: #f9fff4;
        }

        img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 10px;
        }

        .kategori {
            padding: 6px 12px;
            border-radius: 20px;
            color: white;
            font-size: 13px;
            font-weight: bold;
        }

        .snack {
            background: #43a047;
        }

        .minuman {
            background: #1e88e5;
        }

        .btn-delete {
            background: #c62828;
            color: white;
            border: none;
            padding: 8px 14px;
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
            color: gray;
        }
    </style>

</head>

<body>

<div class="sidebar">

    <h2>🌿 Diabetes Admin</h2>

    <a href="/admin/dashboard">🏠 Beranda</a>
    <a href="/admin/pengguna">👤 Data Pengguna</a>
    <a href="/admin/gula-darah">📊 Data Gula Darah</a>
    <a href="/admin/food-items" class="active">🥤 Makanan Dan Minuman</a>
    <a href="/admin/reseps">🍳 Resep</a>

    <a href="/admin/logout" class="logout">🚪 Logout</a>

</div>

<div class="content">

    <div class="header">
        <h1>Food Items</h1>
        <p>Kelola data snack dan minuman yang digunakan pada aplikasi diabetes.</p>
    </div>

    <div class="table-box">

        <a href="/admin/food-items/create" class="btn">
            + Tambah Food Item
        </a>

        @if(session('success'))
            <div class="success">
                {{ session('success') }}
            </div>
        @endif

        <table>

            <thead>

            <tr>
                <th>No</th>
                <th>Gambar</th>
                <th>Nama</th>
                <th>Kategori</th>
                <th>Takaran</th>
                <th>Kalori</th>
                <th>Protein</th>
                <th>Lemak</th>
                <th>Karbo</th>
                <th>Gula</th>
                <th>Aksi</th>
            </tr>

            </thead>

            <tbody>

            @forelse($foods as $food)

            <tr>

                <td>{{ $loop->iteration }}</td>

                <td>

                    @if($food->gambar)
                        <img src="{{ asset($food->gambar) }}">
                    @else
                        -
                    @endif

                </td>

                <td>{{ $food->nama }}</td>

                <td>

                    @if($food->kategori=="snack")
                        <span class="kategori snack">Snack</span>
                    @else
                        <span class="kategori minuman">Minuman</span>
                    @endif

                </td>

                <td>{{ $food->takaran }}</td>

                <td>{{ $food->kalori }} kcal</td>

                <td>{{ $food->protein }} g</td>

                <td>{{ $food->lemak }} g</td>

                <td>{{ $food->karbo }} g</td>

                <td>{{ $food->gula }} g</td>

                <td>

                    <form action="/admin/food-items/{{ $food->id }}" method="POST">

                        @csrf
                        @method('DELETE')

                        <button class="btn-delete"
                            onclick="return confirm('Yakin ingin menghapus data ini?')">
                            Hapus
                        </button>

                    </form>

                </td>

            </tr>

            @empty

            <tr>

                <td colspan="11" class="empty">
                    Belum ada data food item.
                </td>

            </tr>

            @endforelse

            </tbody>

        </table>

        <br>

        {{ $foods->links() }}

    </div>

</div>

</body>

</html>