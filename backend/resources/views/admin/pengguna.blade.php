<!DOCTYPE html>
<html>
<head>
    <title>Data Pengguna</title>
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

        .content {
            margin-left: 250px;
            padding: 30px;
        }

        .header {
            background: white;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 25px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .header h1 {
            color: #2e7d32;
        }

        .table-box {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
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
        }

        tr:hover {
            background: #f1f8e9;
        }

        .empty {
            text-align: center;
            color: #777;
        }

        .pagination {
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>🌿 Diabetes Admin</h2>

    <a href="/admin/dashboard">🏠 Dashboard</a>
    <a href="/admin/pengguna" class="active">👤 Data Pengguna</a>
    <a href="#">📊 Data Gula Darah</a>
    <a href="#">🍽 Menu Makanan</a>
    <a href="#">📖 Resep</a>

    <a href="/admin/logout" class="logout">🚪 Logout</a>
</div>

<div class="content">

    <div class="header">
        <h1>Data Pengguna</h1>
        <p>Daftar pengguna yang terdaftar di aplikasi diabetes.</p>
    </div>

    <div class="table-box">
        <table>
            <thead>
                <tr>
                    <th>No</th>
                    <th>Nama</th>
                    <th>Email</th>
                    <th>Tanggal Lahir</th>
                    <th>Gender</th>
                    <th>Tanggal Daftar</th>
                </tr>
            </thead>

            <tbody>
                @forelse($users as $user)
                    <tr>
                        <td>{{ $loop->iteration }}</td>
                        <td>{{ $user->name ?? '-' }}</td>
                        <td>{{ $user->email ?? '-' }}</td>
                        <td>{{ $user->tanggal_lahir ?? '-' }}</td>
                        <td>{{ $user->gender ?? '-' }}</td>
                        <td>{{ $user->created_at ? $user->created_at->format('d-m-Y') : '-' }}</td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="6" class="empty">Belum ada data pengguna</td>
                    </tr>
                @endforelse
            </tbody>
        </table>

        <div class="pagination">
            {{ $users->links() }}
        </div>
    </div>

</div>

</body>
</html>