<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Documento extends Model
{
    protected $table = 'documento';
    const CPF = '1';
    const CNPJ = '2';
    const CNH = '3';

    protected $fillable = [
        'id_usuario',
        'tipo_documento',
        'numero_documento',
        'orgao_emissor',
        'data_emissao',
        'data_validade',
        'created_at',
        'updated_at',
    ];

    public $timestamps = true;

    public function usuario()
    {
        return $this->belongsTo(User::class, 'id_usuario');
    }
} 