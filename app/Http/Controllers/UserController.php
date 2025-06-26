<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{

    public function getUser(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'nome' => $user->nome,
            'email' => $user->email,
            'id_tipo_usuario' => $user->id_tipo_usuario,
        ]);
    }

    public function updateUser(Request $request)
    {
        $request->validate([
            'nome' => 'required|string|max:255',
        ]);

        $user = $request->user();
        $user->update([
            'nome' => $request->nome
        ]);
        return response()->json([
            'message' => 'Usuário atualizado com sucesso',
        ]);
    }

}
