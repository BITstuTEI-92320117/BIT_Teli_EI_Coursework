#include <stdio.h>
#include <time.h>
#include <windows.h>
#include <stdlib.h>
#include <conio.h>

#define COLOR_WHITE 15
#define COLOR_RED 12
#define COLOR_GREEN 10
#define COLOR_YELLOW 14
#define COLOR_BLUE 9
#define U 1
#define D 2
#define L 3
#define R 4

// 前置声明
class SnakeNode;
class Obstacle;

// 函数声明
void moveSnake(int newX, int newY);
int biteself();
void createfood();
void createObstacles();
int hitObstacle();
void endgame();

// 蛇节点类
class SnakeNode {
private:
    int x;
    int y;
    SnakeNode* next;

    friend void moveSnake(int newX, int newY);
    friend int biteself();
    friend void createfood();
    friend void initsnake();
    friend void snakemove();
    friend void cantcrosswall();
    friend void createObstacles();
	friend int hitObstacle();
    friend void gamecircle();

public:
    SnakeNode(int px, int py, SnakeNode* pnext = nullptr)
        : x(px), y(py), next(pnext) {}
};

// 障碍物类
class Obstacle {
private:
    int x;
    int y;
    Obstacle* next;

    friend void createObstacles();
    friend int hitObstacle();
    friend void gamecircle();

public:
    Obstacle(int px, int py, Obstacle* pnext = nullptr)
        : x(px), y(py), next(pnext) {}
};

// 全局变量
int score = 0, add = 10;
int status, sleeptime = 200;
SnakeNode* head = nullptr, *food = nullptr;
Obstacle* obs_head = nullptr;
int endgamestatus = 0;
int gameMode = 1;
int level = 1;
int paused = 0;

// 颜色设置函数
void SetColor(int color) {
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), color);
}

// 光标定位函数
void Pos(int x, int y) {
    COORD pos = { x, y };
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), pos);
}

// 创建地图
void creatMap() {
    SetColor(COLOR_WHITE);
    for (int i = 0; i < 58; i += 2) {
        Pos(i, 0);
        printf("■");
        Pos(i, 26);
        printf("■");
    }
    for (int i = 1; i < 26; i++) {
        Pos(0, i);
        printf("■");
        Pos(56, i);
        printf("■");
    }
}

// 初始化蛇身
void initsnake() {
    SnakeNode* tail = new SnakeNode(28, 12);
    for (int i = 1; i <= 4; i++) {
        head = new SnakeNode(28 + 2 * i, 12, tail);
        tail = head;
    }

    SetColor(COLOR_RED);
    SnakeNode* current = tail;
    while (current) {
        Pos(current->x, current->y);
        printf("■");
        if (current != head) SetColor(COLOR_WHITE);
        current = current->next;
    }
}

// 自噬检测
int biteself() {
    SnakeNode* self = head->next;
    while (self) {
        if (self->x == head->x && self->y == head->y) return 1;
        self = self->next;
    }
    return 0;
}

// 创建食物
void createfood() {
    while (1) {
        food = new SnakeNode((rand() % 27) * 2 + 2, rand() % 24 + 1);
        int valid = 1;
        SnakeNode* q = head;
        while (q) {
            if (q->x == food->x && q->y == food->y) {
                valid = 0;
                break;
            }
            q = q->next;
        }
        if (valid) break;
        delete food;
    }
    SetColor(COLOR_GREEN);
    Pos(food->x, food->y);
    printf("■");
}

// 创建障碍物
void createObstacles() {
    while (obs_head) {
        Obstacle* tmp = obs_head;
        obs_head = obs_head->next;
        Pos(tmp->x, tmp->y);
		printf("  ");
        delete tmp;
    }

    int obs_num = (level - 1) * 3;
    if (obs_num > 12) obs_num = 12;

    for (int i = 0; i < obs_num; i++) {
        Obstacle* new_obs = nullptr;
        do {
            int x = (rand() % 27) * 2 + 2;
            int y = rand() % 24 + 1;
            new_obs = new Obstacle(x, y);

            bool valid = true;
            SnakeNode* p = head;
            while (p) {
                if (p->x == x && p->y == y) valid = false;
                p = p->next;
            }
            if (food && food->x == x && food->y == y) valid = false;
            if (x <= 0 || x >= 56 || y <= 0 || y >= 26) valid = false;

            Obstacle* exist = obs_head;
            while (exist) {
                if (exist->x == x && exist->y == y) valid = false;
                exist = exist->next;
            }

            if (!valid) {
                delete new_obs;
                new_obs = nullptr;
            }
        } while (!new_obs);

        new_obs->next = obs_head;
        obs_head = new_obs;
        SetColor(COLOR_BLUE);
        Pos(new_obs->x, new_obs->y);
        printf("■");
    }
}

// 移动处理
void moveSnake(int newX, int newY) {
    SnakeNode* nexthead = new SnakeNode(newX, newY, head);

    if (newX == food->x && newY == food->y) {
        head = nexthead;
        score += add;
        SetColor(COLOR_RED);
        Pos(head->x, head->y);
        printf("■");
        createfood();
    } else {
        head = nexthead;
        SetColor(COLOR_RED);
        Pos(head->x, head->y);
        printf("■");

        SnakeNode* current = head->next;
        while (current) {
            SetColor(COLOR_WHITE);
            Pos(current->x, current->y);
            printf("■");
            current = current->next;
        }

        SnakeNode* q = head;
        while (q->next->next) q = q->next;
        Pos(q->next->x, q->next->y);
        printf("  ");
        delete q->next;
        q->next = nullptr;
    }
}

// 撞墙检测
void cantcrosswall() {
    if (head->x <= 0 || head->x >= 56 || head->y <= 0 || head->y >= 26) {
        endgamestatus = 1;
        endgame();
    }
}

// 障碍物碰撞检测
int hitObstacle() {
    Obstacle* p = obs_head;
    while (p) {
        if (head->x == p->x && head->y == p->y) return 1;
        p = p->next;
    }
    return 0;
}

// 关卡升级
void checkLevelUp() {
    int required = level * 100;
    if (score >= required && level < 5) {
        level++;
        createObstacles();
        if (gameMode == 2) {
            sleeptime = 200 - (level - 1) * 30;
            if (sleeptime < 50) sleeptime = 50;
        }
    }
}

// 蛇移动主逻辑
void snakemove() {
    cantcrosswall();
    switch (status) {
        case U: moveSnake(head->x, head->y - 1); break;
        case D: moveSnake(head->x, head->y + 1); break;
        case L: moveSnake(head->x - 2, head->y); break;
        case R: moveSnake(head->x + 2, head->y); break;
    }
    if (biteself()) {
        endgamestatus = 2;
        endgame();
    }
}

// 暂停功能
void pause() {
    paused = 1;
    Pos(64, 19);
    SetColor(COLOR_YELLOW);
    printf("游戏已暂停");
    while (paused) {
        Sleep(50);
        if (GetAsyncKeyState(VK_SPACE)) paused = 0;
        if (GetAsyncKeyState(VK_ESCAPE)) {
            endgamestatus = 3;
            endgame();
        }
    }
    Pos(64, 19);
    printf("          ");
}

// 游戏主循环
void gamecircle() {
    Pos(64, 15);
    SetColor(COLOR_YELLOW);
    printf("操作说明：");
    Pos(64, 16);
    printf("方向键控制移动");
    Pos(64, 17);
    printf("ESC退出 空格暂停");
    if (gameMode == 1) {
        Pos(64, 18);
        printf("F1加速 F2减速 F3重置");
    }

    if (gameMode == 2) {
        createObstacles();
        sleeptime = 200;
    }

    status = R;
    while (1) {
        SetColor(COLOR_YELLOW);
        Pos(64, 9);
        printf("当前模式：%s", gameMode == 1 ? "无限模式" : "闯关模式");
        Pos(64, 10);
        printf("得分：%d ", score);
        Pos(64, 11);
        if (gameMode == 2) {
            printf("当前关卡：Lv.%d ", level);
            Pos(64, 12);
            printf("下一关需：%d分", level * 100);
        } else {
            printf("食物分值：%d ", add);
        }

        if (GetAsyncKeyState(VK_UP) && status != D) status = U;
        else if (GetAsyncKeyState(VK_DOWN) && status != U) status = D;
        else if (GetAsyncKeyState(VK_LEFT) && status != R) status = L;
        else if (GetAsyncKeyState(VK_RIGHT) && status != L) status = R;
        else if (GetAsyncKeyState(VK_SPACE)) pause();
        else if (GetAsyncKeyState(VK_ESCAPE)) {
            endgamestatus = 3;
            endgame();
        }

        if (gameMode == 1) {
            if (GetAsyncKeyState(VK_F1)) {
                sleeptime = (sleeptime > 50) ? sleeptime - 30 : 50;
                add = (add < 20) ? add + 2 : 20;
            }
            else if (GetAsyncKeyState(VK_F2)) {
                sleeptime = (sleeptime < 350) ? sleeptime + 30 : 350;
                add = (add > 1) ? add - 2 : 1;
            }
            else if (GetAsyncKeyState(VK_F3)) {
                sleeptime = 200;
                add = 10;
            }
        }

        Sleep(sleeptime);
        snakemove();

        if (gameMode == 2) {
            checkLevelUp();
            if (hitObstacle()) {
                endgamestatus = 4;
                endgame();
            }
        }
    }
}

// 欢迎界面
void welcometogame() {
    SetColor(COLOR_YELLOW);
    Pos(40, 10);
    printf("请选择游戏模式：");
    Pos(40, 12);
    printf("1 - 无限模式");
    Pos(40, 13);
    printf("2 - 闯关模式");

    while (1) {
        if (GetAsyncKeyState('1')) {
            gameMode = 1;
            break;
        }
        if (GetAsyncKeyState('2')) {
            gameMode = 2;
            add = 10;
            break;
        }
        Sleep(100);
    }
    system("cls");
}

// 结束游戏
void endgame() {
    system("cls");
    SetColor(COLOR_YELLOW);
    Pos(24, 12);
    const char* msg[] = {"撞墙失败！", "咬到自己！", "主动退出游戏", "撞到障碍物！"};
    printf("%s", msg[endgamestatus-1]);
    Pos(24, 13);
    printf("最终得分：%d", score);
    if (gameMode == 2) {
        Pos(24, 14);
        printf("达到关卡：Lv.%d", level);
    }
    Pos(24, 15);
    printf("按任意键退出...");
    _getch();
    exit(0);
}

int main() {
    system("mode con cols=100 lines=30");
    srand((unsigned)time(NULL));
    welcometogame();
    creatMap();
    initsnake();
    createfood();
    gamecircle();
    return 0;
}
