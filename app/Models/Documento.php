<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Documento extends Model
{
    protected $table = 'documento';

    protected $fillable = [
        'id_usuario',
        'id_tipo_documento',
        'numero_documento',
        'orgao_emissor',
        'data_emissao',
        'data_validade',
    ];

    public $timestamps = false;
} 