using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode]
public class GeometryImageGrid : MonoBehaviour
{
    public int _GridSize;
    public int _GridCount;
    public Material _Material;
    public Transform _Object;

    // Start is called before the first frame update
    void Start()
    {
       
    }

    // Update is called once per frame
    void Update()
    {
        _Material.SetMatrix("_ObjectToWorld", _Object.localToWorldMatrix);
        _Material.SetFloat("_GridSize", _GridSize);
        _Material.SetFloat("_GridCount", _GridCount);

        Graphics.DrawProcedural(
            _Material, 
            new Bounds(_Object.position, _Object.localScale * _GridSize),
            MeshTopology.Quads, 4, _GridCount * _GridCount);
    }
}
