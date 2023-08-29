using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TexCtrl : MonoBehaviour
{
    private void Awake()
    {
        mr = GetComponent<MeshRenderer>();
    }

    private void Update()
    {
        mr.material.SetFloat("_Ratio", (Mathf.Sin(Time.time) * 0.5f) + 0.5f);
        // ���̴��� �����ؼ� float���� �������� �̷��� �ڵ鷯 �̸����� ������ �ȴ�.
        // �� �ڿ� *0.5 +0.5 ���̾���.
    }

    private MeshRenderer mr = null;
}