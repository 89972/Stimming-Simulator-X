using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public int currentStage = 1;
    public int score = 0;
    public int combo = 1;

    public float delay = 3600;
    public float timer;

    public static float spawnFrequency = 120f;

    public GameObject bubblePrefab;

    public static GameManager Instance = null;

    void Awake()
    {
        if (Instance != null) // meaning there's already an instance
        {
            gameObject.SetActive(false);
            Destroy(gameObject);
            return;
        }
        Instance = this;
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is calledonce per frame
    void Update()
    {
        timer--;

        if(timer < 1)
        {
            SpawnBubble();
            delay = spawnFrequency / Mathf.Sqrt((score  / 8) + combo);
            timer = delay;
        }
    }

    void SpawnBubble()
    {
        Vector2 pos = Camera.main.ViewportToWorldPoint(new Vector2(Random.value, Random.value));
        Instantiate(bubblePrefab, (Vector3)pos, Quaternion.identity); 
    }
}
