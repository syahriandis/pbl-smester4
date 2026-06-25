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

        .welcome {
            margin-top: 8px;
            color: #555;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
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

        .chart-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
            margin-top: 30px;
        }

        .chart-box {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }

        .chart-box h2 {
            color: #2e7d32;
            margin-bottom: 15px;
            font-size: 20px;
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
            text-align: center;
        }

        @media (max-width: 1000px) {

            .cards,
            .chart-grid {
                grid-template-columns: repeat(2, 1fr);
            }
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
                <h1>{{ $totalGulaDarah }}</h1>
            </div>

            <div class="card">
                <h3>Total Food</h3>
                <h1>{{ $totalFood }}</h1>
            </div>

            <div class="card">
                <h3>Total Resep</h3>
                <h1>{{ $totalResep }}</h1>
            </div>
        </div>

        <div class="chart-grid">
            <div class="chart-box">
                <h2>Grafik Pengguna Baru Per Bulan</h2>
                <canvas id="userChart"></canvas>
            </div>

            <div class="chart-box">
                <h2>Grafik Data Gula Darah Per Bulan</h2>
                <canvas id="gulaChart"></canvas>
            </div>

            <div class="chart-box">
                <h2>Kategori Food</h2>
                <canvas id="foodChart"></canvas>
            </div>

            <div class="chart-box">
                <h2>Status Gula Darah</h2>
                <canvas id="statusGulaChart"></canvas>
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

                @forelse($aktivitasTerbaru as $index => $aktivitas)
                    <tr>
                        <td>{{ $loop->iteration }}</td>
                        <td>{{ $aktivitas['aktivitas'] }}</td>
                        <td>
                            {{ $aktivitas['tanggal'] ? \Carbon\Carbon::parse($aktivitas['tanggal'])->format('d-m-Y H:i') : '-' }}
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="3">Belum ada aktivitas</td>
                    </tr>
                @endforelse
            </table>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        const bulan = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

        const userData = @json($userBulanan);
        const gulaData = @json($gulaBulanan);

        new Chart(document.getElementById('userChart'), {
            type: 'bar',
            data: {
                labels: bulan,
                datasets: [{
                    label: 'Pengguna Baru',
                    data: bulan.map((_, i) => userData[i + 1] ?? 0),
                    backgroundColor: '#2e7d32'
                }]
            }
        });

        new Chart(document.getElementById('gulaChart'), {
            type: 'line',
            data: {
                labels: bulan,
                datasets: [{
                    label: 'Data Gula Darah',
                    data: bulan.map((_, i) => gulaData[i + 1] ?? 0),
                    borderColor: '#2e7d32',
                    backgroundColor: '#a5d6a7',
                    tension: 0.4
                }]
            }
        });

        new Chart(document.getElementById('foodChart'), {
            type: 'pie',
            data: {
                labels: ['Snack', 'Minuman'],
                datasets: [{
                    data: [{{ $foodSnack }}, {{ $foodMinuman }}],
                    backgroundColor: ['#66bb6a', '#1b5e20']
                }]
            }
        });

        new Chart(document.getElementById('statusGulaChart'), {
            type: 'doughnut',
            data: {
                labels: ['Rendah', 'Normal', 'Tinggi'],
                datasets: [{
                    data: [{{ $gulaRendah }}, {{ $gulaNormal }}, {{ $gulaTinggi }}],
                    backgroundColor: ['#42a5f5', '#66bb6a', '#ef5350']
                }]
            }
        });
    </script>

</body>

</html>