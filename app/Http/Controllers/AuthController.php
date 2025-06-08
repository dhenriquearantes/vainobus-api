<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Documento;
use App\Models\TipoDocumento;
use App\Models\TipoUsuario;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function signIn(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'login' => 'required|string',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::where('email', $request->login)->first();

        if (!$user) {
            $documento = Documento::where('numero_documento', $request->login)->first();
            if ($documento && $documento->usuario && $documento->id_tipo_documento == Documento::CPF) {
                $user = $documento->usuario;
            }
        }

        if (!$user || !Hash::check($request->password, $user->senha)) {
            throw ValidationException::withMessages([
                'login' => ['As credenciais fornecidas estão incorretas.'],
            ]);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'data' => $token
        ]);
    }

    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:usuario,email',
            'password' => 'required|string|min:8',
            'cpf' => 'required|string|unique:documento,numero_documento|regex:/^\d{11}$/',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::where('email', $request->email)->first();

        if ($user) {
            return response()->json(['errors' => 'Email já cadastrado'], 422);
        }

        $user = User::create([
            'nome' => $request->name,
            'email' => $request->email,
            'senha' => Hash::make($request->password),
            'id_tipo_usuario' => TipoUsuario::Gestor,
        ]);

        $documento = Documento::create([
            'id_usuario' => $user->id,
            'id_tipo_documento' => TipoDocumento::CPF,
            'numero_documento' => $request->cpf,
        ]);

        $user->id_documento = $documento->id;
        $user->save();

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'data' => [
                'user' => $user,
                'token' => $token
            ]
        ], 201);
    }

    public function recoverPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email|exists:users',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        return response()->json([
            'message' => 'Se o email existir em nossa base, você receberá um link para recuperação de senha.'
        ]);
    }
}
