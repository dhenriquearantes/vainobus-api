<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Workspace;
use Illuminate\Http\Request;

class WorkspaceController extends Controller
{
    public function getWorkspaceByUser($id_usuario)
    {
        $workspace = Workspace::getWorkspaceByUser($id_usuario);
        return response()->json($workspace);
    }

    public function createWorkspace(Request $request)
    {
        $workspace = Workspace::createWorkspace($request->all());
        return response()->json([
            'message' => 'Workspace criado com sucesso',
            'workspace' => $workspace
        ]);
    }

    public function getUsersByWorkspace($id_workspace)
    {
        $users = Workspace::getUsersByWorkspace($id_workspace);
        return response()->json($users);
    }

    public function getWorkspacesByUser($id_usuario)
    {
        $workspaces = Workspace::getWorkspacesByUser($id_usuario);
        return response()->json($workspaces);
    }

}
