//Declaring variables
float x0, y0, xo, yo, x1, y1, x2, y2, x3, y3, theta1, usedTheta2, theta2, s, c, energy;
float xChange, yChange, x, y, speedChange;
int score, time, points, timerReset, highScore, i, level, difficulty, inc, fade;
float levelProgress, countDown, fadeIn;
boolean isSloMo, menuRun, instructionRun, gameRun, keyUp, keyDown, keyLeft, keyRight, twoPlayers, player2Lost;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Food> foods = new ArrayList<Food>();
ArrayList<DedSquare> ded = new ArrayList<DedSquare>();
Player2 player2 = new Player2();
PFont font;
int timLim = 0;
void setup() {
    //fullScreen();
    size(1400, 800);
    frameRate(60); // To debug
    noCursor();
    smooth(8);
    fill(0);
    textSize(100);
    textAlign(CENTER, CENTER);
    noStroke();
    font = loadFont("Prime-Regular-100.vlw");
    textFont(font);
    //Initializing variables
    xo = 0;
    yo = 0;
    x0 = -50;
    y0 = 50;
    x1 = -50;
    y1 = -50;
    x2 = 50;
    y2 = -50;
    x3 = 50;
    y3 = 50;
    difficulty = 3;
    theta1 = radians(10);
    theta2 = radians(-5);
    energy = height*7/8;
    x = random(width);
    y = random(height);
    menuRun = true;
    instructionRun = false;
    fadeIn = 60;
}






void draw() {
    if (menuRun) { //When game opens, shows the menu
        if (instructionRun) {
            background(255);
            text("Click to activate slow motion", width/2, 30);
            text("You can't eat while clicking", width/2, 85);
            text("You destroy food when slow motion", width/2, 145);
            text("for a few seconds. Slow motion drains energy", width/2, 205);
            text("Triangles get faster, and turn faster over time.", width/2, 265);
            if (twoPlayers) {
                text("Player Two", width/2, 325);
                text("You must catch Player One", width/2, 385);
                text("If you touch the food you will lose", width/2, 445);
                text("WASD or Arrow Keys to move", width/2, 505);
            }
            if (enemies.size() < 1) {
                enemies.add(new Enemy(0));
            }
            enemies.get(0).x = width/2;
            enemies.get(0).y = width/2;
            enemies.get(0).rotateEnemy();
            enemies.get(0).drawEnemy();
            enemies.get(0).collisionDetect();
            if (energy == 0) {
                instructionRun = false;
                enemies.remove(0);
            }
        } else {
            textFont(font, 50);
            background(255);
            text("Choose Difficulty", width/2, height/2);
            text("Easier", width/4, height*2/3+60);
            text("Easy", width/2, height*2/3+60);
            text("Normal", width*3/4, height*2/3+60);
            textSize(35);
            text("Instructions", width/10, height/10+60);
            if (!twoPlayers)
                text("Change to two players", width*4/5, height/10+60);
            else
                text("Change to one player", width*4/5, height/10+60);
            fill(255, 0, 0);
            ellipse(width/10, height/10, 50, 50);
            ellipse(width/4, height*2/3, 50, 50);
            ellipse(width/2, height*2/3, 50, 50);
            ellipse(width*3/4, height*2/3, 50, 50);
            ellipse(width*4/5, height/10, 50, 50);
        }
        fill(0);
        pushMatrix();
        translate(mouseX, mouseY);
        quad(x0, y0, x1, y1, x2, y2, x3, y3);
        if (mousePressed) {
            isSloMo = true;
            theta1 = radians(10);
            energy -= height/160;
        } else {
            theta1 = radians(1);
            isSloMo = false;
        }
        rotateSquare();
        popMatrix();
        if (twoPlayers) {
            player2.rotate2();
            player2.move2();
            player2.draw2();
        }
        timLim--;
        if (!instructionRun) {
            if (abs(mouseX-width*4/5) + abs(mouseY - height/10) < 110) {
                if (isSloMo && timLim <= 0) {
                    twoPlayers = !twoPlayers;
                    timLim = 60;
                }
            }
            if (abs(mouseX - width/10) + abs(mouseY - height/10) < 110 && isSloMo && menuRun)
                instructionRun = true;
            if (abs(mouseX - width/4) + abs(mouseY - height*2/3) < 110) {
                if (menuRun) {
                    if (isSloMo) {
                        difficulty = 1;
                        menuRun = false;
                        while (inc < difficulty) {
                            enemies.add(new Enemy((inc+1)*3));
                            inc++;
                        }
                        for (i = 8-difficulty; i>0; i--)
                            foods.add(new Food());
                        for (Enemy i : enemies)
                            i.respawn();
                    }
                }
            }
            if (abs(mouseX - width/2) + abs(mouseY - height*2/3) < 110) {
                if (menuRun) {
                    if (isSloMo) {
                        difficulty = 2;
                        menuRun = false;
                        while (inc < difficulty) {
                            enemies.add(new Enemy((inc+1)*3));
                            inc++;
                        }
                        for (i = 8-difficulty; i>0; i--)
                            foods.add(new Food());
                        for (Enemy i : enemies)
                            i.respawn();
                    }
                }
            }
            if (abs(mouseX - width*3/4) + abs(mouseY - height*2/3) < 110) {
                if (menuRun) {
                    if (isSloMo) {
                        difficulty = 3;
                        menuRun = false;
                        while (inc < difficulty) {
                            enemies.add(new Enemy((inc+1)*3));
                            inc++;
                        }
                        for (i = 8-difficulty; i>0; i--)
                            foods.add(new Food());
                        for (Enemy i : enemies)
                            i.respawn();
                    }
                }
            }
        }
        energy = height;
    } else if (!gameRun) {
        rectMode(CORNER);
        fill(0);
        float floatD = map(fade, 0, 120, -height, 0);
        if (fade < 120) {
            rect(0, floatD, width, height);
            textSize(200);
            fill(255);
            text("Good Luck!", width/2, floatD+height/2);
        } else {
            gameRun = true;
            timerReset = millis();
        }
        fade++;
        rectMode(CENTER);
        fill(0);
    }
    if (gameRun) {
        rectMode(CENTER);
        textSize(80);
        if (energy <= height/8) { //When you die
            if (ded.size() == 0 || ded.size() == 20)
                for (i = 0; i<50; i++) {
                    ded.add(new DedSquare(mouseX, mouseY));
                }
            for (DedSquare i : ded) {
                i.moveSquare();
                i.drawSquare();
            }
            fill(220, 3);
            rectMode(CENTER);
            rect(width/2, height/2, width, height);
            fill(0);
            text("You Died", width/2, height/2);
            text("Press Space To Restart", width/2, height*3/4+100);
            text("Press M To Go Back To Main Menu", width/2, height*3/4);
            if (score > highScore)
                highScore = score;
            text("Score: "+ score, width/2, height/6);
            text("Highest Score: "+highScore, width/2, height/3);
            if (keyPressed && (key == ' ' ||key == 'm')) {
                fadeIn=60;
                if (twoPlayers) {
                    if (mouseY<height/2)
                        player2.y = height;
                    else
                        player2.y = 0;
                    player2Lost = false;
                }

                for (i=ded.size()-1; i>=0; i--)
                    ded.remove(i);
                level = 0;
                levelProgress = 0;
                speedChange = 0;
                for (Food i : foods)
                    i.deadFood = -3000;
                for (Enemy i : enemies)
                {
                    i.respawn();
                    i.deadTime = 0;
                }
                for (i = foods.size()-1; i>=0; i--)
                    foods.remove(i);
                for (i = 8-difficulty; i>0; i--)
                    foods.add(new Food());
                energy = height*7/8;
                timerReset = millis(); //Timer reset (because the millis() function can't be reset to 0)
                if (key == 'm') {
                    gameRun = false;
                    menuRun = true;
                }
            }
        } else {
            score = time + points;
            if (energy > height*7/8)
                energy = height*7/8;
            background(255);     //Reseting the background
            pushMatrix();
            translate(mouseX, mouseY);     //Make the mouse position the origin so the rotation works
            quad(x0, y0, x1, y1, x2, y2, x3, y3);     //Drawing the square
            if (mousePressed) {
                isSloMo = true;
                theta1 = radians(10);
                energy -= height/320;
            } else {
                theta1 = radians(1);
                isSloMo = false;
            }
            //Doing the rotations
            rotateSquare();
            popMatrix();//Resetting the origin to draw everything else
            //Energy bar
            quad(width*15/16, height/8+(height*7/8-energy), width*31/32, height/8+(height*7/8-energy), width*31/32, height*7/8, width*15/16, height*7/8);
            energy -= (abs(pmouseX-mouseX) + abs(pmouseY - mouseY))/7;
            if (key == 'l')
                energy = height*7/8;
            if (energy < height*7/8)
                energy -= .1;
            //Timer/Score Keeper
            time = (int)(millis()-timerReset)+points;
            text(time, width/8, height*17/18);

            //Drawing Triangles
            for (Enemy i : enemies) {
                i.rotateEnemy();
                i.move();
                i.drawEnemy();
                i.collisionDetect();
            }
            if (twoPlayers && !player2Lost) { //Player 2
                player2.rotate2();
                player2.move2();
                player2.draw2();
                player2.collisionDetect2();
            }
            //Drawing Food
            for (i = foods.size()-1; i>=0; i--) {
                if (foods.get(i).gotGot) {
                    foods.remove(i);
                }
                if (foods.size() == 0) {
                    score += 1000;
                    levelProgress += 400;
                    for (i = 8-difficulty; i>0; i--)
                        foods.add(new Food());
                }
            }
            if (key == 'l') {
                textSize(30);
                text("Infinite Energy Cheat Active", width/2, height*7/8);
            }
            fill(100);
            for (Food i : foods) {
                i.drawFood();
            }
            fill(0);
            //Level Progressor
            if (levelProgress > 1200) {
                speedChange += 1;
                for (Enemy i : enemies)
                    i.maxTurn += PI/128;
                level++;
                countDown = 60;
                levelProgress = 0;
                levelProgress++;
            }
            if (countDown != 0) {
                textSize(countDown);
                text(level, width/2, height/2);
                countDown--;
            }
            if (fadeIn>0) {
                float fadeS = map(fadeIn, 0, 60, 60, width*2);
                rect(mouseX, mouseY, fadeS, fadeS);
                fadeIn--;
            }
        }
    }
}
//Rotate x coordinate method
float rotateX(float x, float y, float angle, float xCenter) {
    s = sin(angle);
    c = cos(angle);
    x -= xCenter;
    x = x * c - y * s;
    x += xCenter;
    return x;
}
//Rotate y coordinate method
float rotateY(float x, float y, float angle, float yCenter) {
    s = sin(angle);
    c = cos(angle);
    y -= yCenter;
    y = x * s + y * c;
    y += yCenter;
    return y;
}
void rotateSquare() {
    float x0Rotated = rotateX(x0, y0, theta1, xo);
    y0 = rotateY(x0, y0, theta1, yo);
    x0 = x0Rotated;
    float x1Rotated = rotateX(x1, y1, theta1, xo);
    y1 = rotateY(x1, y1, theta1, yo);
    x1 = x1Rotated;
    float x2Rotated = rotateX(x2, y2, theta1, xo);
    y2 = rotateY(x2, y2, theta1, yo);
    x2 = x2Rotated;
    float x3Rotated = rotateX(x3, y3, theta1, xo);
    y3 = rotateY(x3, y3, theta1, yo);
    x3 = x3Rotated;
}
void keyPressed() {
    if (key == 'w' || keyCode == UP)
        keyUp = true;
    if (key == 's' || keyCode == DOWN)
        keyDown = true;
    if (key == 'a' || keyCode == LEFT)
        keyLeft = true;
    if (key == 'd' || keyCode == RIGHT)
        keyRight = true;
}

void keyReleased() {
    if (key == 'w' || keyCode == UP)
        keyUp = false;
    if (key == 's' || keyCode == DOWN)
        keyDown = false;
    if (key == 'a' || keyCode == LEFT)
        keyLeft = false;
    if (key == 'd' || keyCode == RIGHT)
        keyRight = false;
}


class Enemy {
    float x = width/2;
    float y = height/2;
    float x1;
    float x2 = -20;
    float x3 = 20;
    float y1 = (+(sqrt(3)/3)*40);
    float y2 = (-(sqrt(3)/6)*40);
    float y3 = (-(sqrt(3)/6)*40);
    float speed;
    float x1Rotated;
    float x2Rotated;
    float x3Rotated;
    float direction;
    float maxTurn = PI/96;
    float usedMaxTurn;
    boolean inBounds = false;
    int deadTime;
    boolean firstRun = true;
    Enemy(float tempSpeed) {
        speed = tempSpeed;
    }
    void rotateEnemy() {
        if (isSloMo)
            usedTheta2 = theta2/3;
        else
            usedTheta2 = theta2;
        x1Rotated = rotateX(x1, y1, usedTheta2, 0);
        y1 = rotateY(x1, y1, usedTheta2, 0);
        x1 = x1Rotated;
        x2Rotated = rotateX(x2, y2, usedTheta2, 0);
        y2 = rotateY(x2, y2, usedTheta2, 0);
        x2 = x2Rotated;
        x3Rotated = rotateX(x3, y3, usedTheta2, 0);
        y3 = rotateY(x3, y3, usedTheta2, 0);
        x3 = x3Rotated;
    }
    void move() { //A way to move a set amount towards another point/on a line
        if (isSloMo)
            usedMaxTurn = maxTurn/3;
        else
            usedMaxTurn = maxTurn;
        float overallSpeed;
        if (isSloMo)
            overallSpeed = (speed + speedChange)/3;
        else
            overallSpeed = speed + speedChange;
        float moveX = mouseX - x;
        float moveY = mouseY - y;
        float dist = sqrt(moveX * moveX + moveY * moveY);
        moveX /= dist;
        moveY /= dist;
        float turnX = cos(direction);
        float turnY = sin(direction);
        float angle = asin(moveX * turnY - moveY * turnX);
        if (-moveY * turnY - moveX * turnX < 0) {
            angle = sin(angle) * PI - angle;
        }
        if (angle < 0) {
            if (angle < -usedMaxTurn) {
                angle = -usedMaxTurn;
            }
        } else {
            if (angle > usedMaxTurn) {
                angle = usedMaxTurn;
            }
        }
        direction -= angle;
        x += cos(direction) * (overallSpeed);
        y += sin(direction) * (overallSpeed);
    }
    void drawEnemy() {
        fill(255, 0, 0);
        pushMatrix();
        translate(x, y);
        triangle(x1, y1, x2, y2, x3, y3);
        popMatrix();
        fill(0);
    }
    void collisionDetect() {
        if (abs(mouseX-x) + abs(mouseY-y)  < 80)
            energy = 0;

        if ((x > 25 && x < width-25) && (y < height-25 && y > 25))
            inBounds = true;

        else if (x < -5 || x > width+5 || y < -5 || y > height+5)
            inBounds = false;

        if (inBounds) {
            if ((x <= 20 || x >= width-20) || (y >= height-20 || y <= 20)) {
                if (direction<PI)
                    direction += PI;
                else
                    direction -= PI;
            }
        } else if (!inBounds) {
            if (millis()-timerReset > 10000) {
                x = 200;
                y = 200;
                inBounds = true;
            }
        }
    }
    void respawn() {
        int ranQuadrant1 = (int)random(0, 2);
        int ranSide1 = (int)random(0, 2);
        if (ranQuadrant1 == 0) {
            if (ranSide1 == 0)
                x = random(-50, -width/2);
            else {
                x = random(width+50, 3*width/2);
            }
            y = random(-height/2, 3*height/2);
        } else {
            if (ranSide1 == 0)
                y = random(-50, -height/2);
            else {
                y = random(height+50, 3*height/2);
            }
            x = random(-width/2, 3*width/2);
        }
        inBounds = false;
    }
}

class Food {
    float x;
    float y;
    int deadFood = -3000;
    boolean gotGot = false;
    Food() {
        x = random(0, width);
        y = random(0, height);
    }
    void drawFood() {

        if ((millis()-timerReset) - deadFood > 2000) {
            ellipse(x, y, 30, 30);
            if (foodCollide()) {
                if (isSloMo) {
                    deadFood = millis();
                } else {
                    energy += height/6;
                    gotGot = true;
                }
            }
        }
    }
    boolean foodCollide() {
        if (abs(player2.x - x) + abs(player2.y -y) <50) {
            if (ded.size() == 0)
                for (i = 0; i<20; i++) {
                    ded.add(new DedSquare(player2.x, player2.y));
                    player2Lost = true;
                }
        }
        for (DedSquare i : ded) {
            i.moveSquare();
            i.drawSquare();
        }
        if (abs(mouseX - x) + abs(mouseY - y) < 80)
            return true;
        else
            return false;
    }
}

class DedSquare {
    PVector pos;
    PVector velocity;
    float limit;

    DedSquare(float x, float y) {
        pos = new PVector(x, y);
        velocity = new PVector(random(-20, 20), random(-20, 20));
    }
    void moveSquare() {
        pos.add(velocity);
    }
    void drawSquare() {
        rect(pos.x, pos.y, 10, 10);
    }
}

class Player2 {
    int x = 400;
    int y = 400;
    float x1;
    float x2 = -20;
    float x3 = 20;
    float y1 = (+(sqrt(3)/3)*40);
    float y2 = (-(sqrt(3)/6)*40);
    float y3 = (-(sqrt(3)/6)*40);
    float x1Rotated;
    float x2Rotated;
    float x3Rotated;
    float speed = 10;
    Player2() {
    }

    void move2() {
        /* Failed Attempt to make movement similar to enemies.
         if (keyLeft)
         a-=PI/96;
         if (keyRight)
         a+=PI/96;
         dirX = (cos(a) - sin(a)*20)+x;
         dirY = (cos(a) + sin(a)*20)+y;
         slope = (y - dirX)/(x-dirY);
         float atanSlope = atan(slope);
         if (slope < 0 && dirY < y ) {
         x += cos(atanSlope)*(speed + speedChange);
         y += sin(atanSlope)*(speed + speedChange);
         } else if (slope >= 0 && dirY < y) {
         x -= cos(atanSlope)*(speed + speedChange);
         y -= sin(atanSlope)*(speed + speedChange);
         } else if (slope > 0) {
         x += cos(atanSlope)*(speed + speedChange);
         y += sin(atanSlope)*(speed + speedChange);
         } else {
         x -= cos(atanSlope)*(speed + speedChange);
         y -= sin(atanSlope)*(speed + speedChange);
         }*/
        if (keyUp && y>20)
            y -= speed;
        if (keyDown && y<height-20)
            y += speed;
        if (keyLeft && x>20)
            x -= speed;
        if (keyRight && x<width-20)
            x += speed;
    }
    void rotate2() {
        if (isSloMo)
            usedTheta2 = theta2/3;
        else
            usedTheta2 = theta2;
        x1Rotated = rotateX(x1, y1, usedTheta2, 0);
        y1 = rotateY(x1, y1, usedTheta2, 0);
        x1 = x1Rotated;
        x2Rotated = rotateX(x2, y2, usedTheta2, 0);
        y2 = rotateY(x2, y2, usedTheta2, 0);
        x2 = x2Rotated;
        x3Rotated = rotateX(x3, y3, usedTheta2, 0);
        y3 = rotateY(x3, y3, usedTheta2, 0);
        x3 = x3Rotated;
    }
    void draw2() {
        fill(255, 0, 0);
        pushMatrix();
        translate(x, y);
        triangle(x1, y1, x2, y2, x3, y3);
        popMatrix();
        fill(0);
        ellipse(x, y, 10, 10);
    }
    void collisionDetect2() {
        if (abs(mouseX-x) + abs(mouseY-y)  < 80)
            energy = 0;
    }
}