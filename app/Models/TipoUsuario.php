<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TipoUsuario extends Model
{
    protected $table = 'tipo_usuario';
    const Gestor = 1;
    const Motorista = 2;
    const Aluno = 3;

    protected $fillable = [
        'nome',
    ];

    public $timestamps = false;
} 