<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'data' => [
                'user' => $user,
                'stats' => [
                    // TODO: Implementar estatísticas do usuário
                    'total_rides' => 0,
                    'favorite_routes' => [],
                    'recent_activities' => []
                ]
            ]
        ]);
    }
}
