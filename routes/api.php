<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\WorkspaceController;

Route::post('/user/signin', [AuthController::class, 'signIn']);
Route::post('/user/register', [AuthController::class, 'register']);
Route::post('/user/recover-password', [AuthController::class, 'recoverPassword']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index']);
    Route::get('/user/me', [UserController::class, 'getUser']);
    Route::post('/workspace/create', [WorkspaceController::class, 'createWorkspace']);
}); 