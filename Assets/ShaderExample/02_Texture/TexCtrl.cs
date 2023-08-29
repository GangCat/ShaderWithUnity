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
        // 쉐이더랑 연동해서 float값을 넣으려면 이렇게 핸들러 이름으로 던지면 된다.
        // 저 뒤에 *0.5 +0.5 많이쓴다.
    }

    private MeshRenderer mr = null;
}