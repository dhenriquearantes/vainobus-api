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
        $documento = $user->documentos()->first();

        return response()->json([
            'id' => $user->id,
            'nome' => $user->nome,
            'email' => $user->email,
            'id_tipo_usuario' => $user->id_tipo_usuario,
            'documento' => $documento ? [
                'id' => $documento->id,
                'numero' => $documento->numero_documento,
            ] : null,
            'created_at' => $user->created_at ? $user->created_at->toISOString() : null,
            'updated_at' => $user->updated_at ? $user->updated_at->toISOString() : null,
        ]);
    }

}
