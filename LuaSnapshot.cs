using UnityEngine;
using UnityEditor;
using System;
using LuaInterface;
using LuaFramework;

public class LuaSnapshot {

    [MenuItem("LuaSnapshot/LuaSnapshotPrint")]
    static void LuaSnapshotPrint()
    {       
        LuaManager mgr = AppFacade.Instance.GetManager<LuaManager>(ManagerName.Lua);
        mgr.CallFunction("Game.dump");
    }
}
