<!DOCTYPE html>
<html>

<head>
    <title>Dashboard Admin Diabetes</title>
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
            transition: 0.3s;
        }

        .sidebar a:hover {
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

        .header {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 25px;
        }

        .header h1 {
            color: #2e7d32;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            border-left: 6px solid #4caf50;
        }

        .card h3 {
            color: #666;
            margin-bottom: 10px;
        }

        .card h1 {
            color: #2e7d32;
            font-size: 36px;
        }

        .welcome {
            margin-top: 8px;
            color: #555;
        }

        .table-section {
            margin-top: 30px;
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }

        .table-section h2 {
            color: #2e7d32;
            margin-bottom: 15px;
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
        }
    </style>
</head>

<body>

    <div class="sidebar">
        <h2>🌿 Diabetes Admin</h2>

        <a href="/admin/dashboard">🏠 Dashboard</a>
        <a href="/admin/pengguna">👤 Data Pengguna</a>
        <a href="#">📊 Data Gula Darah</a>
        <a href="#">🍽 Menu Makanan</a>
        <a href="#">📖 Resep</a>

        <a href="/admin/logout" class="logout">🚪 Logout</a>
    </div>

    <div class="content">

        <div class="header">
            <h1>Dashboard Admin</h1>
            <p class="welcome">
                Selamat datang,
                <b>{{ session('admin_nama') }}</b>
            </p>
        </div>

        <div class="cards">

            <div class="card">
                <h3>Total Pengguna</h3>
                <h1>{{ $totalPengguna }}</h1>
            </div>

            <div class="card">
                <h3>Data Gula Darah</h3>
                <h1>0</h1>
            </div>

            <div class="card">
                <h3>Total Menu</h3>
                <h1>0</h1>
            </div>

        </div>

        <div class="table-section">
            <h2>Aktivitas Terbaru</h2>

            <table>
                <tr>
                    <th>No</th>
                    <th>Aktivitas</th>
                    <th>Tanggal</th>
                </tr>

                <tr>
                    <td>1</td>
                    <td>Belum ada aktivitas</td>
                    <td>-</td>
                </tr>

            </table>
        </div>

    </div>

</body>

</html>