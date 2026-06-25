<!DOCTYPE html>
<html>

<head>
    <title>Data Gula Darah</title>
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
            margin-bottom: 25px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }

        .header h1 {
            color: #2e7d32;
        }

        .table-box {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
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

        .status-normal {
            background: #dcfce7;
            color: #166534;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
        }

        .status-tinggi {
            background: #fee2e2;
            color: #991b1b;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
        }

        .status-rendah {
            background: #dbeafe;
            color: #1e40af;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
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

        <a href="/admin/dashboard">🏠 Beranda</a>
        <a href="/admin/pengguna">👤 Data Pengguna</a>
        <a href="/admin/gula-darah">📊 Data Gula Darah</a>
        <a href="/admin/food-items">🥤 Makanan Dan Minuman</a>
        <a href="/admin/reseps">🍳 Resep</a>

        <a href="/admin/logout" class="logout">🚪 Logout</a>
    </div>

    <div class="content">

        <div class="header">
            <h1>Data Gula Darah</h1>
            <p>Riwayat catatan gula darah pengguna aplikasi diabetes.</p>
        </div>

        <div class="table-box">
            <table>
                <thead>
                    <tr>
                        <th>No</th>
                        <th>Nama Pengguna</th>
                        <th>Email</th>
                        <th>Tanggal</th>
                        <th>Waktu</th>
                        <th>Nilai Gula</th>
                        <th>Status</th>
                    </tr>
                </thead>

                <tbody>
                    @forelse($dataGulaDarah as $item)
                        @php
                            if ($item->nilai_gula < 70) {
                                $status = 'Rendah';
                                $class = 'status-rendah';
                            } elseif ($item->nilai_gula <= 140) {
                                $status = 'Normal';
                                $class = 'status-normal';
                            } else {
                                $status = 'Tinggi';
                                $class = 'status-tinggi';
                            }
                        @endphp

                        <tr>
                            <td>{{ $loop->iteration }}</td>
                            <td>{{ $item->user->name ?? '-' }}</td>
                            <td>{{ $item->user->email ?? '-' }}</td>
                            <td>{{ $item->tanggal ?? '-' }}</td>
                            <td>{{ $item->waktu ?? '-' }}</td>
                            <td>{{ $item->nilai_gula ?? '-' }} mg/dL</td>
                            <td>
                                <span class="{{ $class }}">{{ $status }}</span>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="7" class="empty">Belum ada data gula darah</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>

            <div class="pagination">
                {{ $dataGulaDarah->links() }}
            </div>
        </div>

    </div>

</body>

</html>