using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Bubble : MonoBehaviour
{
    public float floatSpeed = 1f;
    public float size = 1;
    public Vector3 direction = Vector3.up;

    public SpriteRenderer spriteRenderer;

    // Start is called before the first frame update
    void Start()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
        spriteRenderer.color = GenerateRandomColor();

        size = 1 + (Random.value / 2);

        transform.DOScale(new Vector3(size, size, 1), 0.5f);
        switch(UnityEngine.Random.Range(0, 3))
        {
            case 0:
                direction = Vector3.down;
            break;
            case 1:
                direction = Vector3.left;
            break;
            case 2:
                direction = Vector3.right;
            break;
            case 3:
                direction = Vector3.up;
            break;
        }
    }

    // Update is called once per frame
    void Update()
    {
        transform.Translate(direction * floatSpeed * Time.deltaTime);
    }

    IEnumerator OnMouseDown()
    {
        Debug.Log("Click!");
        transform.DOScale(new Vector3(size*1.5f, size*1.5f, 1), 0.25f);
        yield return new WaitForSeconds(0.25f);
        transform.DOScale(Vector3.zero, 0.25f);
        spriteRenderer.DOFade(0f, 0.25f);
        yield return new WaitForSeconds(0.25f);


        GameManager.Instance.score++;
        GameManager.Instance.bubbleCount--;
        Destroy(gameObject);
    }

    void OnBecameInvisible()
    {
        GameManager.Instance.bubbleCount--;
        Destroy(gameObject);
    }

    public Color GenerateRandomColor()
    {
        float red = Random.Range(0f, 1f);  
        float green = Random.Range(0f, 1f);
        float blue = Random.Range(0f, 1f);  

        return new Color(red, green, blue);
    }


}
