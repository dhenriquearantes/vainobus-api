<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TipoDocumento extends Model
{
    protected $table = 'tipo_documento';
    const CPF = 1;
    const CNPJ = 2;
    const CNH = 3;

    protected $fillable = [
        'nome',
    ];

    public $timestamps = false;
} 