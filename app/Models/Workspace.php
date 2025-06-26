<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;

class Workspace extends Authenticatable
{
    protected $table = 'workspace';

    protected $fillable = [
        'nome',
        'id_usuario',
    ];

    public $timestamps = false;

    public function getWorkspaceByUser($id_usuario)
    {
        return $this->where('id_usuario', $id_usuario)->first();
    }

    public function createWorkspace($data)
    {
        return $this->create($data);
    }

    public function getUsersByWorkspace($id_workspace)
    {
        return $this->where('id_workspace', $id_workspace)->get();
    }

    public function getWorkspacesByUser($id_usuario)
    {
        return $this->where('id_usuario', $id_usuario)->get();
    }
}
