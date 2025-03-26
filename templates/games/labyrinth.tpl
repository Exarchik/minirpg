<style>
    body { 
        text-align: center; 
        font-family: Arial, sans-serif; 
        background-color: #222; 
        color: white; 
        margin: 0;
        padding: 20px;
        perspective: 1000px;
        overflow: hidden;
    }
    h2 {
        text-shadow: 0 0 10px rgba(255,255,255,0.3);
        margin-bottom: 10px;
    }
    .maze-container {
        display: inline-block;
        margin: 20px auto;
        transform-style: preserve-3d;
        transform: rotateX(15deg) rotateY(0deg);
        transition: transform 0.5s ease;
        position: relative;
        z-index: 1;
        animation: rotateMaze 15s infinite linear;
    }
    .maze-container:hover {
        animation-play-state: paused;
    }
    canvas { 
        border: 2px solid #555; 
        background-color: #111; 
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.8);
        transform-style: preserve-3d;
    }
    button { 
        margin: 10px; 
        padding: 12px 25px; 
        font-size: 16px; 
        cursor: pointer; 
        background: linear-gradient(145deg, #444, #333);
        color: white; 
        border: none; 
        border-radius: 30px; 
        box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        transition: all 0.3s ease;
        outline: none;
    }
    button:hover { 
        background: linear-gradient(145deg, #555, #444);
        transform: translateY(-2px);
        box-shadow: 0 7px 20px rgba(0,0,0,0.4);
    }
    button:active {
        transform: translateY(0);
        box-shadow: 0 3px 10px rgba(0,0,0,0.3);
    }
    .info-panel {
        margin: 15px auto;
        padding: 10px;
        background: rgba(0,0,0,0.3);
        border-radius: 10px;
        max-width: 500px;
    }
    .fruits-counter {
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
        gap: 10px;
        margin-top: 10px;
    }
    .fruit-icon {
        font-size: 20px;
        opacity: 0.25;
        transition: all 0.3s;
        filter: grayscale(100%);
    }
    .fruit-icon.collected {
        opacity: 1;
        transform: scale(1.25);
        filter: grayscale(0%);
    }
    .fruit-icon.all-collected {
        animation: pulse 0.5s infinite alternate;
    }
    .timer {
        font-size: 18px;
        margin: 10px 10px;
        display: inline-block;
    }
    .level {
        font-size: 18px;
        margin: 10px 0;
        color: #4CAF50;
        display: inline-block;
    }
    .info-panel.all-collected {
        animation: info-panel-anim 1s infinite linear;
    }
    @keyframes info-panel-anim {
      0% { background: radial-gradient(circle, green, #222); }
      50% { background: radial-gradient(circle, #333, #222); }
      100% { background: radial-gradient(circle, green, #222); }
    }
    @keyframes shake {
        0% { transform: rotateX(15deg) rotateY(5deg) translateX(0); }
        25% { transform: rotateX(15deg) rotateY(5deg) translateX(-5px); }
        50% { transform: rotateX(15deg) rotateY(5deg) translateX(5px); }
        75% { transform: rotateX(15deg) rotateY(5deg) translateX(-5px); }
        100% { transform: rotateX(15deg) rotateY(5deg) translateX(0); }
    }
    @keyframes float {
        0% { transform: rotateX(15deg) rotateY(5deg) translateY(0) scale(1); }
        50% { transform: rotateX(15deg) rotateY(5deg) translateY(-5px) scale(1.02); }
        100% { transform: rotateX(15deg) rotateY(5deg) translateY(0) scale(1); }
    }
    @keyframes rotateMaze {
        0% { transform: rotateX(15deg) rotateY(0deg); }
        25% { transform: rotateX(0deg) rotateY(10deg); }
        50% { transform: rotateX(-15deg) rotateY(0deg); }
        75% { transform: rotateX(0deg) rotateY(-10deg); }
        100% { transform: rotateX(15deg) rotateY(0deg); }
    }
    @keyframes pulse {
        0% { transform: scale(1); opacity: 1; }
        100% { transform: scale(1.3); opacity: 0.85; }
    }
    .confetti {
        position: absolute;
        width: 5px;
        height: 10px;
        background-color: #f00;
        pointer-events: none;
        z-index: 2;
    }
    .win-message {
        position: fixed;
        top: 65%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: rgba(0,0,0,0.8);
        padding: 20px;
        border-radius: 10px;
        z-index: 100;
        display: none;
    }
    .loading {
        position: fixed;
        top: 65%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: rgba(0,0,0,0.7);
        padding: 20px;
        border-radius: 10px;
        z-index: 100;
    }
</style>

<h2>{__('GAME_FRUITS_AND_VEGETABLES')}</h2>
    <div class="level">{__('GENERAL_LEVEL')}: 1 (4x4)</div>
    <div class="timer">{__('GENERAL_TIME')}: 00:00</div>
    <div class="info-panel">
        <div id="info-panel-text">{__('COLLECT_ALL_FOODS_BEFORE_EXITING')}!</div>
        <div class="fruits-counter" id="fruitsContainer">
            <!-- Fruits will be added here dynamically -->
        </div>
    </div>
    <div class="maze-container">
        <canvas id="mazeCanvas"></canvas>
    </div>
    <br>
    <button onclick="generateMaze()">{__('GENERATE_NEW_MAZE')}</button>
    <div class="win-message" id="winMessage"></div>
    <div class="loading" id="loading">{__('GENERATING_MAZE')}...</div>

{ignore}
    <script>
        const canvas = document.getElementById("mazeCanvas");
        const ctx = canvas.getContext("2d");
        const fruitsContainer = document.getElementById("fruitsContainer");
        const timerElement = document.querySelector('.timer');
        const infoPanelElement = document.querySelector('.info-panel');
        const winMessage = document.getElementById('winMessage');
        const levelElement = document.querySelector('.level');
        const loadingElement = document.getElementById('loading');

        const minSize = 4;
        const maxSize = 10;
        let currentSize = 4;
        let cellSize = 40;
        
        // Розширений список хавла (40 різних жрачок)
        const allFruitEmojis = [
            '🍗', '🍖', '🥙', '🥓', '🌭', '🍣', '🧀', '🍩', '🍯', '☕',
            '🍏', '🍎', '🍐', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🍈',
            '🍒', '🍑', '🥭', '🍍', '🥥', '🥝', '🍅', '🍆', '🥑', '🥦',
            '🥬', '🥒', '🍔', '🌽', '🥕', '🧄', '🧅', '🥔', '🍠', '🥐'
        ];
        
        const faces = {'simple': '😐', 'excited': '😁', 'happy': '😊'};
        
        let grid = [];
        let stack = [];
        let current;
        let entry, exit, player;
        let fruits = [];
        let collectedFruits = 0;
        let totalFruits = 3;
        let startTime;
        let timerInterval;
        let level = 1;
        let currentLevelFruits = []; // Фрукти для поточного рівня
        let isMazeGenerated = false;
        let isAnimating = true;

        function updateCanvasSize() {
            cellSize = Math.max(20, Math.min(40, 600 / currentSize));
            canvas.width = currentSize * cellSize;
            canvas.height = currentSize * cellSize;
            levelElement.textContent = `{/ignore}{__("GENERAL_LEVEL")}{ignore}: ${level} (${currentSize}x${currentSize})`;
        }

        function updateFruitsCount() {
            totalFruits = 3 + Math.floor((level - 1) / 2);
            
            // Вибір випадкових фруктів для цього рівня
            currentLevelFruits = [...allFruitEmojis]
                .sort(() => 0.5 - Math.random())
                .slice(0, totalFruits);
            
            fruitsContainer.innerHTML = '';
            for (let i = 0; i < totalFruits; i++) {
                const fruitIcon = document.createElement('span');
                fruitIcon.className = 'fruit-icon';
                fruitIcon.setAttribute('data-type', currentLevelFruits[i]);
                fruitIcon.setAttribute('style', 'animation-delay: ' + (i * 0.05) + 's');
                fruitIcon.textContent = currentLevelFruits[i];
                fruitsContainer.appendChild(fruitIcon);
            }
        }

        function updateFruitsUI() {
            const fruitIcons = document.querySelectorAll('.fruit-icon');
            fruitIcons.forEach(icon => {
                const fruitType = icon.getAttribute('data-type');
                const isCollected = fruits.some(f => f.type === fruitType && f.collected);
                icon.classList.toggle('collected', isCollected);
                
                // Add special highlight when all fruits collected
                if (collectedFruits === totalFruits) {
                    icon.classList.add('all-collected');
                    infoPanelElement.classList.add('all-collected');
                    document.getElementById("info-panel-text").innerHTML = `{/ignore}{__('ALL_FOODS_COLLECTED')}{ignore}!`;
                } else {
                    icon.classList.remove('all-collected');
                    infoPanelElement.classList.remove('all-collected');
                    document.getElementById("info-panel-text").innerHTML = `{/ignore}{__('COLLECT_ALL_FOODS_BEFORE_EXITING')}{ignore}!`;
                }
            });
        }

        class Cell {
            constructor(x, y) {
                this.x = x;
                this.y = y;
                this.visited = false;
                this.walls = { top: true, right: true, bottom: true, left: true };
                this.hasFruit = false;
                this.fruitType = null;
                this.fruitIndex = -1;
            }

            draw() {
                const x = this.x * cellSize;
                const y = this.y * cellSize;

                // 3D floor effect
                ctx.fillStyle = this.visited ? "#333" : "#222";
                ctx.fillRect(x, y, cellSize, cellSize);

                // Wall shadows for 3D effect
                if (this.walls.bottom) {
                    ctx.fillStyle = "rgba(0, 0, 0, 0.5)";
                    ctx.fillRect(x, y + cellSize - 4, cellSize, 4);
                }
                if (this.walls.right) {
                    ctx.fillStyle = "rgba(0, 0, 0, 0.4)";
                    ctx.fillRect(x + cellSize - 4, y, 4, cellSize);
                }

                // Exit marker
                if (this === exit) {
                    // Highlight exit when all fruits collected
                    ctx.fillStyle = collectedFruits === totalFruits ? "rgba(0, 255, 0, 0.3)" : "rgba(255, 0, 0, 0.5)";
                    ctx.fillRect(x, y, cellSize, cellSize);
                    ctx.fillStyle = "#fff";
                    ctx.font = "bold 24px Arial";
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";
                    ctx.fillText("🚪", x + cellSize/2, y + cellSize/2);
                }

                // Player emoji
                if (this === player) {
                    ctx.fillStyle = "rgba(255, 235, 59, 1)";
                    ctx.font = `${cellSize * 0.7}px Arial`;
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";
                    var currentFace = collectedFruits === totalFruits ? (this === exit ? faces['excited'] : faces['happy']) : faces['simple'];
                    ctx.fillText(currentFace, x + cellSize / 2, y + cellSize / 2);
                }

                // Fruits
                if (this.hasFruit && this.fruitIndex !== -1 && !fruits[this.fruitIndex].collected) {
                    ctx.font = `${cellSize * 0.6}px Arial`;
                    ctx.fillStyle = "rgba(255, 255, 255, 1)";
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";
                    ctx.fillText(this.fruitType, x + cellSize / 2, y + cellSize / 2);
                }

                // Wall highlights
                ctx.lineWidth = 2;
                if (this.walls.top) {
                    ctx.strokeStyle = "#ddd";
                    ctx.beginPath();
                    ctx.moveTo(x, y);
                    ctx.lineTo(x + cellSize, y);
                    ctx.stroke();
                    ctx.strokeStyle = "#777";
                    ctx.beginPath();
                    ctx.moveTo(x, y+1);
                    ctx.lineTo(x + cellSize, y+1);
                    ctx.stroke();
                }
                if (this.walls.right) {
                    ctx.strokeStyle = "#ddd";
                    ctx.beginPath();
                    ctx.moveTo(x + cellSize, y);
                    ctx.lineTo(x + cellSize, y + cellSize);
                    ctx.stroke();
                    ctx.strokeStyle = "#777";
                    ctx.beginPath();
                    ctx.moveTo(x + cellSize-1, y);
                    ctx.lineTo(x + cellSize-1, y + cellSize);
                    ctx.stroke();
                }
                if (this.walls.bottom) {
                    ctx.strokeStyle = "#ddd";
                    ctx.beginPath();
                    ctx.moveTo(x, y + cellSize);
                    ctx.lineTo(x + cellSize, y + cellSize);
                    ctx.stroke();
                    ctx.strokeStyle = "#777";
                    ctx.beginPath();
                    ctx.moveTo(x, y + cellSize-1);
                    ctx.lineTo(x + cellSize, y + cellSize-1);
                    ctx.stroke();
                }
                if (this.walls.left) {
                    ctx.strokeStyle = "#ddd";
                    ctx.beginPath();
                    ctx.moveTo(x, y);
                    ctx.lineTo(x, y + cellSize);
                    ctx.stroke();
                    ctx.strokeStyle = "#777";
                    ctx.beginPath();
                    ctx.moveTo(x+1, y);
                    ctx.lineTo(x+1, y + cellSize);
                    ctx.stroke();
                }
            }
        }

        function generateGrid() {
            grid = [];
            for (let y = 0; y < currentSize; y++) {
                for (let x = 0; x < currentSize; x++) {
                    grid.push(new Cell(x, y));
                }
            }
            current = grid[0];
            current.visited = true;
            stack = [];
            collectedFruits = 0;
            fruits = [];
            setEntryExit();
            updateFruitsUI();
        }

        function getIndex(x, y) {
            if (x < 0 || y < 0 || x >= currentSize || y >= currentSize) return -1;
            return x + y * currentSize;
        }

        function getUnvisitedNeighbor(cell) {
            let neighbors = [];
            let directions = [
                { dx: 0, dy: -1, wall1: "top", wall2: "bottom" },
                { dx: 1, dy: 0, wall1: "right", wall2: "left" },
                { dx: 0, dy: 1, wall1: "bottom", wall2: "top" },
                { dx: -1, dy: 0, wall1: "left", wall2: "right" }
            ];

            for (let dir of directions) {
                let neighborIndex = getIndex(cell.x + dir.dx, cell.y + dir.dy);
                if (neighborIndex !== -1 && !grid[neighborIndex].visited) {
                    neighbors.push({ cell: grid[neighborIndex], wall1: dir.wall1, wall2: dir.wall2 });
                }
            }

            return neighbors.length > 0 ? neighbors[Math.floor(Math.random() * neighbors.length)] : null;
        }

        function removeWall(cellA, cellB, wallA, wallB) {
            cellA.walls[wallA] = false;
            cellB.walls[wallB] = false;
        }

        function placeFruits() {
            // Clear previous fruits
            fruits = [];
            grid.forEach(cell => {
                cell.hasFruit = false;
                cell.fruitType = null;
                cell.fruitIndex = -1;
            });

            // Get all cells that are path (not walls) and not entry/exit
            const possibleCells = grid.filter(cell => {
                const isPath = !cell.walls.top || !cell.walls.bottom || !cell.walls.left || !cell.walls.right;
                return isPath && cell !== entry && cell !== exit;
            });

            // Shuffle array and pick needed number of cells
            const shuffled = [...possibleCells].sort(() => 0.5 - Math.random());
            const selectedCells = shuffled.slice(0, Math.min(totalFruits, possibleCells.length));

            // Place fruits - використовуємо currentLevelFruits замість fruitEmojis
            selectedCells.forEach((cell, index) => {
                cell.hasFruit = true;
                cell.fruitType = currentLevelFruits[index];
                cell.fruitIndex = index;
                fruits.push({
                    x: cell.x,
                    y: cell.y,
                    type: currentLevelFruits[index],
                    collected: false,
                    index: index
                });
            });
        }

        function stepMaze() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            
            // Draw background with perspective effect
            ctx.fillStyle = "#111";
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            
            for (let cell of grid) {
                cell.draw();
            }

            let next = getUnvisitedNeighbor(current);
            if (next) {
                stack.push(current);
                removeWall(current, next.cell, next.wall1, next.wall2);
                current = next.cell;
                current.visited = true;
            } else if (stack.length > 0) {
                current = stack.pop();
            }

            if (stack.length > 0) {
                requestAnimationFrame(stepMaze);
            } else {
                console.log("Maze generated!");
                // Ensure exit is accessible by removing one wall
                makeExitAccessible();
                placeFruits();
                drawMaze();
                startTimer();
                isMazeGenerated = true;
                isAnimating = false;
                loadingElement.style.display = 'none';
            }
        }

        function makeExitAccessible() {
            // Remove one wall from exit to make it accessible
            const directions = [
                { wall: "top", dx: 0, dy: -1 },
                { wall: "right", dx: 1, dy: 0 },
                { wall: "bottom", dx: 0, dy: 1 },
                { wall: "left", dx: -1, dy: 0 }
            ];
            
            // Try each direction until we find a valid cell to connect to
            for (const dir of directions) {
                const nx = exit.x + dir.dx;
                const ny = exit.y + dir.dy;
                if (nx >= 0 && nx < currentSize && ny >= 0 && ny < currentSize) {
                    exit.walls[dir.wall] = false;
                    grid[getIndex(nx, ny)].walls[
                        dir.wall === "top" ? "bottom" :
                        dir.wall === "right" ? "left" :
                        dir.wall === "bottom" ? "top" : "right"
                    ] = false;
                    break;
                }
            }
        }

        function setEntryExit() {
            let edges = [];
            for (let i = 0; i < currentSize; i++) {
                edges.push(grid[getIndex(i, 0)]);
                edges.push(grid[getIndex(i, currentSize - 1)]);
            }
            for (let i = 1; i < currentSize - 1; i++) {
                edges.push(grid[getIndex(0, i)]);
                edges.push(grid[getIndex(currentSize - 1, i)]);
            }

            entry = edges[Math.floor(Math.random() * edges.length)];
            exit = edges[Math.floor(Math.random() * edges.length)];
            while (entry === exit) exit = edges[Math.floor(Math.random() * edges.length)];

            player = entry;
        }

        function collectFruit() {
            const cellIndex = getIndex(player.x, player.y);
            const cell = grid[cellIndex];
            
            if (cell.hasFruit && cell.fruitIndex !== -1 && !fruits[cell.fruitIndex].collected) {
                fruits[cell.fruitIndex].collected = true;
                collectedFruits++;
                updateFruitsUI();
                
                // Animation effect
                const container = document.querySelector('.maze-container');
                container.style.animation = 'none';
                void container.offsetWidth;
                container.style.animation = 'float 0.5s ease-out';
            }
        }

        function startTimer() {
            clearInterval(timerInterval);
            startTime = new Date();
            timerInterval = setInterval(updateTimer, 1000);
        }

        function updateTimer() {
            const currentTime = new Date();
            const elapsedTime = Math.floor((currentTime - startTime) / 1000);
            const minutes = Math.floor(elapsedTime / 60).toString().padStart(2, '0');
            const seconds = (elapsedTime % 60).toString().padStart(2, '0');
            timerElement.textContent = `{/ignore}{__('GENERAL_TIME')}{ignore}: ${minutes}:${seconds}`;
        }

        function createConfetti() {
            const colors = ['#f00', '#0f0', '#00f', '#ff0', '#f0f', '#0ff'];
            for (let i = 0; i < 100; i++) {
                const confetti = document.createElement('div');
                confetti.className = 'confetti';
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.left = `${Math.random() * 100}vw`;
                confetti.style.top = '-10px';
                confetti.style.content = '*';
                confetti.style.transform = `rotate(${Math.random() * 360}deg)`;
                
                const animationDuration = Math.random() * 3 + 2;
                confetti.style.animation = `fall ${animationDuration}s linear forwards`;
                
                document.body.appendChild(confetti);
                
                // Remove confetti after animation
                setTimeout(() => {
                    confetti.remove();
                }, animationDuration * 1000);
            }
            
            // Add falling animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes fall {
                    to {
                        transform: translateY(100vh) rotate(360deg);
                    }
                }
            `;
            document.head.appendChild(style);
        }

        function showWinMessage(timeSpent) {
            winMessage.textContent = `{/ignore}{__('CONGRATULATIONS')}{ignore}! {/ignore}{__('YOU_SOLVED_THE_MAZE_IN')}{ignore} ${timeSpent}!`;
            winMessage.style.display = 'block';
            setTimeout(() => {
                winMessage.style.display = 'none';
                if (currentSize < maxSize) {
                    currentSize++;
                    level++;
                    generateMaze();
                } else {
                    level++;
                    generateMaze();
                }
            }, 3000);
        }

        function movePlayer(dx, dy) {
            if (!isMazeGenerated || isAnimating) return;
            
            let newIndex = getIndex(player.x + dx, player.y + dy);
            if (newIndex === -1) return;

            let newCell = grid[newIndex];
            if (
                (dx === -1 && !player.walls.left) ||
                (dx === 1 && !player.walls.right) ||
                (dy === -1 && !player.walls.top) ||
                (dy === 1 && !player.walls.bottom)
            ) {
                player = newCell;
                
                collectFruit();
                
                if (player === exit && collectedFruits === totalFruits) {
                    isAnimating = true;
                    clearInterval(timerInterval);
                    const currentTime = new Date();
                    const elapsedTime = Math.floor((currentTime - startTime) / 1000);
                    const minutes = Math.floor(elapsedTime / 60);
                    const seconds = elapsedTime % 60;
                    const timeString = `${minutes}m ${seconds}s`;
                    
                    createConfetti();
                    showWinMessage(timeString);
                }
            }
            drawMaze();
        }

        function drawMaze() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            for (let cell of grid) {
                cell.draw();
            }
        }

        document.addEventListener("keydown", (e) => {
            if (e.key === "ArrowUp") movePlayer(0, -1);
            if (e.key === "ArrowRight") movePlayer(1, 0);
            if (e.key === "ArrowDown") movePlayer(0, 1);
            if (e.key === "ArrowLeft") movePlayer(-1, 0);
        });

        function generateMaze() {
            isMazeGenerated = false;
            loadingElement.style.display = 'block';
            updateCanvasSize();
            updateFruitsCount();
            const container = document.querySelector('.maze-container');
            container.style.animation = 'none';
            void container.offsetWidth;
            container.style.animation = 'shake 0.3s';
            
            generateGrid();
            stepMaze();
        }

        // Initialize the game
        generateMaze();
    </script>
{/ignore}