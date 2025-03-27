<style>
        body {
            margin: 0;
            overflow: hidden;
            background-color: #222;
            user-select: none;
        }
        canvas {
            display: block;
        }
        #ui {
            position: absolute;
            bottom: 10px;
            left: 10px;
            color: white;
            font-family: Arial, sans-serif;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 20px;
            width: 100%;
        }
        #score {
            position: absolute;
            right: 25px;
            align-items: center;
        }
        #lives {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .life {
            font-size: 28px;
            color: #ff5252;
            display: inline-block;
        }
        #gameOver {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: red;
            font-family: Arial, sans-serif;
            font-size: 72px;
            font-weight: bold;
            text-align: center;
            display: none;
        }
        #restartBtn {
            margin-top: 20px;
            padding: 10px 20px;
            font-size: 24px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        #restartBtn:hover {
            background-color: #2980b9;
        }
        .powerup {
            font-size: 30px;
            position: absolute;
            pointer-events: none;
            animation: float 3s ease-in-out infinite;
            text-shadow: 0 0 10px rgba(255, 255, 255, 0.7);
            z-index: 10;
        }
        .heart-emoji {
            color: #ff5252;
            text-shadow: 0 0 10px rgba(255, 82, 82, 0.7);
        }
        .bomb-emoji {
            color: #333;
            text-shadow: 0 0 10px rgba(255, 165, 0, 0.7);
        }
        @keyframes float {
            0%, 100% { transform: translateY(0) scale(1); }
            50% { transform: translateY(-15px) scale(1.1); }
        }
        @keyframes explosion {
            0% { transform: scale(0.5); opacity: 1; }
            100% { transform: scale(3); opacity: 0; }
        }
        .explosion-effect {
            position: absolute;
            font-size: 100px;
            animation: explosion 0.8s ease-out forwards;
            pointer-events: none;
            z-index: 20;
        }
    </style>
    <div id="ui">
        <div id="lives">❤️: <div id="lives-container"></div></div>
        <div id="score">Score: <span>0</span></div>
    </div>
    <div id="gameOver">
        GAME OVER<br>
        <span id="finalScore">Score: 0</span><br>
        <button id="restartBtn">Restart</button>
    </div>
    <canvas id="gameCanvas"></canvas>

{ignore}
    <script>
        // Canvas setup
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');
        const scoreElement = document.querySelector('#score span');
        const livesContainer = document.getElementById('lives-container');
        const gameOverElement = document.getElementById('gameOver');
        const finalScoreElement = document.getElementById('finalScore');
        const restartBtn = document.getElementById('restartBtn');
        
        // Set canvas to full window size
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
        
        // Game variables
        let score = 0;
        let lives = 5;
        let gameActive = true;
        let lastHeartTime = Date.now();
        let lastBombTime = Date.now();
        const enemies = [];
        const powerups = [];
        const playerSize = 30;
        const playerColor = '#3498db';

        // 0 - slowest 1 - slow 2 - normal 3 - fast 4 - very fast
        const enemyColors = ['#e74c3c', '#f39c12', '#2ecc71', '#328ad1', '#9b59b6'];
        const eliteEnemyColor = '#f1c40f';
        
        // Player position (center of the screen)
        const player = {
            x: canvas.width / 2,
            y: canvas.height / 2
        };

        // Initialize lives display
        function updateLivesDisplay() {
            livesContainer.innerHTML = lives;
            /*for (let i = 0; i < lives; i++) {
                const heart = document.createElement('div');
                heart.className = 'life';
                heart.innerHTML = '❤️';
                livesContainer.appendChild(heart);
            }*/
        }
        updateLivesDisplay();
        
        // Enemy class
        class Enemy {
            constructor(healthAmount = 1) {
                this.isElite = healthAmount > 1 ? true : false;
                this.isUltraElite = healthAmount === 5 ? true : false;
                
                // Random position on the edge of the screen
                const edge = Math.floor(Math.random() * 4); // 0: top, 1: right, 2: bottom, 3: left
                
                switch (edge) {
                    case 0: // top
                        this.x = Math.random() * canvas.width;
                        this.y = -20;
                        break;
                    case 1: // right
                        this.x = canvas.width + 20;
                        this.y = Math.random() * canvas.height;
                        break;
                    case 2: // bottom
                        this.x = Math.random() * canvas.width;
                        this.y = canvas.height + 20;
                        break;
                    case 3: // left
                        this.x = -20;
                        this.y = Math.random() * canvas.height;
                        break;
                }
                
                this.health = healthAmount;
                // 0.0625 - 0.5625
                this.speed = healthAmount === 5 ? 0.1 : (0.0625 + Math.random() * 0.5);
                // 0 - 4
                // точний розрахунок залежності кольору від швидкості
                this.color = enemyColors[Math.round(this.speed * 8 - 0.5)];

                if (this.isElite) {
                    this.size = 40 + Math.random() * 20;
                } else {
                    this.size = 20 + Math.random() * 20;
                }
            }
            
            update() {
                // Calculate direction toward player
                const dx = player.x - this.x;
                const dy = player.y - this.y;
                const distance = Math.sqrt(dx * dx + dy * dy);
                
                // Move toward player
                this.x += (dx / distance) * this.speed;
                this.y += (dy / distance) * this.speed;
            }
            
            draw() {
                ctx.fillStyle = this.color;
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
                ctx.fill();
                
                // Draw health indicator for elite enemies or enemies with health > 1
                if (this.health > 1 || this.isElite) {
                    ctx.fillStyle = 'white';
                    ctx.font = `${this.size / 1}px Arial`;
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'middle';
                    ctx.fillText(this.health.toString(), this.x, this.y);
                }
            }
            
            isClicked(mouseX, mouseY) {
                const distance = Math.sqrt(
                    Math.pow(mouseX - this.x, 2) + 
                    Math.pow(mouseY - this.y, 2)
                );
                return distance <= this.size;
            }
        }
        
        // Powerup class
        class Powerup {
            constructor(type) {
                this.type = type; // 'heart' or 'bomb'
                this.x = Math.random() * (canvas.width - 40) + 20;
                this.y = Math.random() * (canvas.height - 40) + 20;
                this.size = 40;
                this.lifetime = type === 'heart' ? 5000 : 4000; // 5s for heart, 4s for bomb
                this.createdAt = Date.now();
                this.element = this.createElement();
            }
            
            createElement() {
                const element = document.createElement('div');
                element.className = `powerup ${this.type}-emoji`;
                element.innerHTML = this.type === 'heart' ? '❤️' : '💣';
                element.style.left = `${this.x - this.size/2}px`;
                element.style.top = `${this.y - this.size/2}px`;
                element.style.fontSize = `${this.size}px`;
                document.body.appendChild(element);
                return element;
            }
            
            updatePosition() {
                this.element.style.left = `${this.x - this.size/2}px`;
                this.element.style.top = `${this.y - this.size/2}px`;
            }
            
            isClicked(mouseX, mouseY) {
                const rect = this.element.getBoundingClientRect();
                return mouseX >= rect.left && 
                       mouseX <= rect.right && 
                       mouseY >= rect.top && 
                       mouseY <= rect.bottom;
            }
            
            isExpired() {
                return Date.now() - this.createdAt > this.lifetime;
            }
            
            remove() {
                this.element.remove();
            }
        }
        
        // Create explosion effect
        function createExplosion(x, y) {
            const explosion = document.createElement('div');
            explosion.className = 'explosion-effect';
            explosion.innerHTML = '💥';
            explosion.style.left = `${x - 50}px`;
            explosion.style.top = `${y - 50}px`;
            document.body.appendChild(explosion);
            
            // Remove after animation
            setTimeout(() => explosion.remove(), 1000);
        }
        
        // Game loop
        function gameLoop() {
            if (!gameActive) return;
            
            // Clear canvas
            ctx.fillStyle = 'rgba(34, 34, 34, 0.2)';
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            
            // Draw player
            ctx.fillStyle = playerColor;
            ctx.beginPath();
            ctx.arc(player.x, player.y, playerSize, 0, Math.PI * 2);
            ctx.fill();
            
            // Spawn new enemies randomly
            if (enemies.length < 10) {
                if (Math.random() < 0.025) {
                    enemies.push(new Enemy());
                }
                
                // Spawn elite enemies less frequently
                if (Math.random() < 0.00125) {
                    enemies.push(new Enemy(2));
                }
                
                // Spawn ultra-elite enemies less frequently
                if (Math.random() < 0.000125) {
                    enemies.push(new Enemy(5));
                }
            }
            
            // Spawn hearts every 30-60 seconds
            const currentTime = Date.now();
            if (currentTime - lastHeartTime > 30000 + Math.random() * 30000) {
                powerups.push(new Powerup('heart'));
                lastHeartTime = currentTime;
            }
            
            // Spawn bombs every 60-90 seconds
            if (currentTime - lastBombTime > 60000 + Math.random() * 30000) {
                powerups.push(new Powerup('bomb'));
                lastBombTime = currentTime;
            }
            
            // Update and draw enemies
            for (let i = enemies.length - 1; i >= 0; i--) {
                enemies[i].update();
                enemies[i].draw();
                
                // Check if enemy reached player
                const distanceToPlayer = Math.sqrt(
                    Math.pow(enemies[i].x - player.x, 2) + 
                    Math.pow(enemies[i].y - player.y, 2)
                );
                
                if (distanceToPlayer < playerSize + enemies[i].size) {
                    // Remove enemy
                    enemies.splice(i, 1);
                    
                    // Decrease player lives
                    lives--;
                    updateLivesDisplay();
                    
                    // Check for game over
                    if (lives <= 0) {
                        gameOver();
                    }
                }
            }
            
            // Update powerups
            for (let i = powerups.length - 1; i >= 0; i--) {
                powerups[i].updatePosition();
                
                // Remove expired powerups
                if (powerups[i].isExpired()) {
                    powerups[i].remove();
                    powerups.splice(i, 1);
                }
            }
            
            requestAnimationFrame(gameLoop);
        }
        
        function gameOver() {
            gameActive = false;
            finalScoreElement.textContent = `Score: ${score}`;
            gameOverElement.style.display = 'block';
            
            // Remove all powerups
            powerups.forEach(powerup => powerup.remove());
            powerups.length = 0;
        }
        
        function restartGame() {
            // Reset game state
            score = 0;
            lives = 5;
            enemies.length = 0;
            powerups.length = 0;
            lastHeartTime = Date.now();
            lastBombTime = Date.now();
            gameActive = true;
            
            // Update UI
            scoreElement.textContent = score;
            updateLivesDisplay();
            gameOverElement.style.display = 'none';
            
            // Restart game loop
            gameLoop();
        }
        
        // Mouse click handler
        document.addEventListener('click', (e) => {
            if (!gameActive) return;
            
            const mouseX = e.clientX;
            const mouseY = e.clientY;
            
            // First check powerups (priority over enemies)
            for (let i = powerups.length - 1; i >= 0; i--) {
                if (powerups[i].isClicked(mouseX, mouseY)) {
                    if (powerups[i].type === 'heart') {
                        // Add life (max 10 lives)
                        lives = Math.min(lives + 1, 10);
                        updateLivesDisplay();
                        
                        // Create floating effect
                        const floatEffect = document.createElement('div');
                        floatEffect.className = 'powerup heart-emoji';
                        floatEffect.innerHTML = '❤️';
                        floatEffect.style.left = `${mouseX - 15}px`;
                        floatEffect.style.top = `${mouseY - 15}px`;
                        floatEffect.style.animation = 'float 1.5s ease-out forwards';
                        document.body.appendChild(floatEffect);
                        floatEffect.remove();
                    } 
                    else if (powerups[i].type === 'bomb') {
                        // Calculate points for all enemies
                        let points = 0;
                        enemies.forEach(enemy => {
                            points += enemy.isElite ? (enemy.isUltraElite ? 200 : 50) : 10;
                        });
                        
                        // Add points
                        score += points;
                        scoreElement.textContent = score;
                        
                        // Create explosion effect
                        createExplosion(mouseX, mouseY);
                        
                        // Remove all enemies
                        enemies.length = 0;
                    }
                    
                    powerups[i].remove();
                    powerups.splice(i, 1);
                    return; // Exit after collecting powerup
                }
            }
            
            // Then check enemies
            const rect = canvas.getBoundingClientRect();
            const canvasMouseX = e.clientX - rect.left;
            const canvasMouseY = e.clientY - rect.top;
            
            for (let i = enemies.length - 1; i >= 0; i--) {
                if (enemies[i].isClicked(canvasMouseX, canvasMouseY)) {
                    enemies[i].health--;
                    
                    if (enemies[i].health <= 0) {
                        // Add score (more for elite enemies)
                        const points = enemies[i].isElite ? (enemies[i].isUltraElite ? 200 : 50) : 10;
                        score += points;
                        scoreElement.textContent = score;
                        
                        enemies.splice(i, 1);
                    }
                    break; // Only hit one enemy per click
                }
            }
        });
        
        // Handle window resize
        window.addEventListener('resize', () => {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
            player.x = canvas.width / 2;
            player.y = canvas.height / 2;
        });
        
        // Restart button
        restartBtn.addEventListener('click', restartGame);
        
        // Start the game
        gameLoop();
    </script>
{/ignore}