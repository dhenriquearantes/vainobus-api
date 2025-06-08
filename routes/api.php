<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DashboardController;

Route::post('/user/signin', [AuthController::class, 'signIn']);
Route::post('/user/register', [AuthController::class, 'register']);
Route::post('/user/recover-password', [AuthController::class, 'recoverPassword']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index']);
}); 