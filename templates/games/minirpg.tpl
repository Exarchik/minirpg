    <style>
        body {
            font-family: 'Courier New', monospace;
            max-width: 1300px;
            margin: 0 auto;
            padding: 20px;
            background-color: #222;
            color: #eee;
        }
        #game {
            background-color: #333;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.3);
        }
        button {
            padding: 8px 15px;
            margin: 5px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-family: 'Courier New', monospace;
        }
        button:hover {
            background-color: #45a049;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(3px);
        }

        .modal-content {
            background-color: #333;
            margin: 15% auto;
            padding: 25px;
            border: 2px solid #4CAF50;
            border-radius: 10px;
            width: 80%;
            max-width: 500px;
            position: relative;
            animation: modalWindowFadeIn 0.3s;
            text-align: center;
        }

        .modal-button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 25px;
            margin-top: 20px;
            border-radius: 5px;
            cursor: pointer;
            font-family: 'Courier New', monospace;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .modal-button:hover {
            background-color: #45a049;
        }

        #modal-message {
            margin: 20px 0;
            font-size: 18px;
            line-height: 1.6;
            color: #eee;
        }

        @keyframes modalWindowFadeIn {
            from { opacity: 0; transform: translateY(-50px); }
            to { opacity: 1; transform: translateY(0); }
        }

        #resurrectBtn {
            background-color: #8B0000;
            padding: 8px 15px;
            margin: 5px;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-family: 'Courier New', monospace;
            display: none; /* Початково прихована */
        }

        #resurrectBtn:hover {
            background-color: #A52A2A;
        }

        #resurrectBtn:active {
            transform: scale(0.98);
        }

        #log {
            height: 33vh;
            overflow-y: scroll;
            border: 1px solid #444;
            padding: 10px;
            margin-top: 10px;
            background-color: #252525;
            line-height: 1.5;
        }
        .player { color: #55f; }
        .enemy { color: #f55; }
        .system { color: #5f5; }
        .loot { color: #f5f; }
        .item { color: #ff5; }
        .sell { color: #fa0; }
        .artifact { color: #f8f; }
        #enemy-emoji, #player-emoji {
            position: relative;
        }
        #battle-view {
            display: flex;
            justify-content: space-around;
            margin: 10px 0;
            font-size: 48px;
            text-align: center;
        }
        .health-bar {
            height: 10px;
            background-color: #444;
            margin-top: 5px;
            border-radius: 5px;
            overflow: hidden;
        }
        .health-fill {
            height: 100%;
            background-color: #f00;
            width: 100%;
            transition: width 0.3s;
        }
        .player-health .health-fill {
            background-color: #0a0;
        }
        .xp-bar {
            height: 10px;
            background-color: #444;
            margin-top: 5px;
            border-radius: 5px;
            overflow: hidden;
        }
        .xp-fill {
            height: 100%;
            background-color: #f00;
            width: 100%;
            transition: width 0.3s;
        }
        .player-xp .xp-fill {
            background-color: #fff400;
        }
        .stats {
            font-size: 14px;
            margin-top: 5px;
        }
        #inventory {
            margin-top: 15px;
            padding: 10px;
            background-color: #252525;
            border-radius: 5px;
        }
        .item-slot {
            display: inline-block;
            margin: 5px;
            padding: 5px;
            background-color: #444;
            border-radius: 3px;
            cursor: pointer;
            position: relative;
        }
        .item-slot:hover {
            background-color: #555;
        }
        .equipped {
            border: 2px solid gold;
            background-color: #5a5a2a;
        }
        .item-actions {
            display: none;
            position: absolute;
            top: 30px;
            left: 0;
            background-color: #555;
            border-radius: 3px;
            z-index: 10;
        }
        .item-slot:hover .item-actions {
            display: block;
        }
        .item-action {
            padding: 3px 6px;
            font-size: 12px;
            cursor: pointer;
        }
        .item-action:hover {
            background-color: #666;
        }
        #equipment {
            margin-top: 10px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 5px;
        }
        .equipment-slot {
            display: block;
            padding: 5px;
            background-color: #3a3a3a;
            border-radius: 3px;
            min-width: 60px;
            text-align: center;
        }
        #map-container {
            margin: 15px 0;
            position: relative;
        }
        #map {
            display: grid;
            grid-template-columns: repeat(10, 1fr);
            gap: 2px;
            width: 72%;
            justify-self: center;
        }
        .map-cell {
            width: 40px;
            height: 40px;
            background-color: #444;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            cursor: pointer;
            border-radius: 3px;
            transition: all 0.2s;
        }
        .map-cell:hover {
            background-color: #555;
        }
        .visited-cell {
            background-color: #3a3a3a;
        }
        .player-cell {
            background-color: #55f;
        }
        .enemy-cell {
            background-color: rgb(255, 181, 85);
            animation: pulse 1.5s infinite;
        }
        .elite-cell {
            background-color: rgb(240, 78, 78);
            animation: pulse 1.5s infinite;
        }
        .boss-cell {
            background-color: rgb(255, 0, 0);
            animation: pulse 1.5s infinite;
        }
        .artifact-cell {
            background-color: #f8f;
            animation: glow 2s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        @keyframes glow {
            0% { box-shadow: 0 0 5px #f8f; }
            50% { box-shadow: 0 0 20px #f8f; }
            100% { box-shadow: 0 0 5px #f8f; }
        }
        #controls {
            margin-top: 10px;
        }
        .flex-container {
            display: flex;
            gap: 20px;
        }
        .game-column {
            flex: 1 2;
        }
        .artifact-bonus {
            font-size: 12px;
            color: #f8f;
        }
        
        /* Стилі для критичної шкоди */
        .critical-hit {
            color: #ff0;
            font-weight: bold;
            animation: flash 0.3s;
        }
        @keyframes flash {
            0% { opacity: 0; transform: scale(1.5); }
            50% { opacity: 1; transform: scale(1.2); }
            100% { opacity: 1; transform: scale(1); }
        }
        
        /* Стилі для еліксирів */
        .potion-health { color: #f00; }
        .potion-attack { color: #ff0; }
        .potion-defense { color: #0f0; }
        .potion-cell {
            background-color: #79c4f7;
            animation: potion-glow 1s infinite alternate;
        }
        @keyframes potion-glow {
            from { box-shadow: 0 0 5px #79c4f7; }
            to { box-shadow: 0 0 20px #79c4f7; }
        }
        
        /* Анімація атаки */
        @keyframes shake {
            0% { transform: translate(1px, 0); }
            25% { transform: translate(-2px, 0); }
            50% { transform: translate(2px, 0); }
            75% { transform: translate(-1px, 0); }
            100% { transform: translate(0, 0); }
        }
        .shake {
            animation: shake 0.2s infinite;
        }

        .flash-red {
            animation: flashRed 0.4s;
        }
        @keyframes flashRed {
            0% { background-color: rgba(255,0,0,0.3); }
            100% { background-color: transparent; }
        }
        
        /* Стилі для анімації шкоди */
        @keyframes popup {
            0% { opacity: 1; transform: translateY(0); }
            100% { opacity: 0; transform: translateY(-50px); }
        }
        
        .event-popup {
            font-size: 24px;
            font-weight: bold;
            animation: popup 1s forwards;
            pointer-events: none;
            z-index: 100;
        }
        
        .event-popup-slow {
            font-size: 24px;
            font-weight: bold;
            animation: popup 3s forwards;
            pointer-events: none;
            z-index: 100;
        }

        .damage-popup {
            color: #f00;
        }

        .heal-popup {
            color: #0f0;
        }

        .gold-popup {
            color: #ff0;
        }

        .xp-popup {
            color: #88f;
        }

        .fruit-cell {
            animation: fruit-pulse 2s infinite;
            border-radius: 50%;
        }

        @keyframes fruit-pulse {
            0% { transform: scale(1); box-shadow: 0 0 5px currentColor; }
            50% { transform: scale(1.1); box-shadow: 0 0 15px currentColor; }
            100% { transform: scale(1); box-shadow: 0 0 5px currentColor; }
        }

        /* Додаткові стилі для різних типів фруктів */
        .fruit-cell[data-fruit="25"] { color: #ff555554; background-color: #ff555554; }
        .fruit-cell[data-fruit="50"] { color: #ffaa0054; background-color: #ffaa0054; }
        .fruit-cell[data-fruit="100"] { color: #55ff5554; background-color: #55ff5554; }

        /* Перешкоди */
        .obstacle-cell {
            cursor: not-allowed;
            position: relative;
        }

        .tree-cell {
            background-color: #1a3a1a;
            color: #2a8a2a;
        }

        .mountain-cell {
            background-color: #3a3a3a;
            color: #cccccc;
        }

        .obstacle-cell::after {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.3);
            border-radius: 3px;
        }
    </style>
    <div id="game">
        <h1>🏰 Емодзі RPG з артефактами 🏰</h1>
        
        <div id="game-modal" class="modal">
            <div class="modal-content">
                <p id="modal-message"></p>
                <button id="modal-ok" class="modal-button">OK</button>
            </div>
        </div>

        <div class="flex-container">
            <div class="game-column">
                <div id="map-container">
                    <h3>🗺️ Карта</h3>
                    <div id="map"></div>
                </div>
                
                <div id="battle-view">
                    <div id="player-view">
                        <div id="player-emoji">🧙‍♂️</div>
                        <div class="health-bar player-health">
                            <div class="health-fill" id="player-health-bar"></div>
                        </div>
                        <div class="xp-bar player-xp">
                            <div class="xp-fill" id="player-xp-bar"></div>
                        </div>
                        <div class="stats">АТК: <span id="attack-display">10</span> | ЗАХ: <span id="defense-display">5</span> | ❤️: <span id="max-health-display">100</span></div>
                    </div>
                    <div id="vs">⚔️</div>
                    <div id="enemy-view" style="display: block;">
                        <div id="enemy-emoji">👤</div>
                        <div class="health-bar">
                            <div class="health-fill" id="enemy-health-bar"></div>
                        </div>
                        <div class="stats" id="enemy-stats">АТК: ? | ЗАХ: ? | ❤️: 0</div>
                    </div>
                </div>
                
                <div id="controls">
                    <button id="healBtn" style="display: none;">💊 Лікуватися (10 золота)</button>
                    <button id="resurrectBtn" style="display: none;">💀 Воскреснути</button>
                </div>
            </div>
            
            <div class="game-column">
                <div id="stats">
                    <p>🏆 Рівень: <span id="level">1</span> | 💰 Золото: <span id="gold">0</span> | 📈 Досвід: <span id="xp">0</span>/<span id="xpToNext">50</span></p>
                </div>
                
                <div id="equipment">
                    <div>⚔️ Зброя: <span id="weapon-slot" class="equipment-slot">Пусто</span></div>
                    <div>🛡️ Броня: <span id="armor-slot" class="equipment-slot">Пусто</span></div>
                    <div>💍 Кільце: <span id="ring-slot" class="equipment-slot">Пусто</span></div>
                    <div>📿 Амулет: <span id="amulet-slot" class="equipment-slot">Пусто</span></div>
                    <div>📖 Книга: <span id="book-slot" class="equipment-slot">Пусто</span></div>
                    <div>🏆 Реліквія: <span id="relic-slot" class="equipment-slot">Пусто</span></div>
                </div>
                
                <div id="inventory">
                    <div>🎒 Інвентар</div>
                    <div id="inventory-items"></div>
                </div>
                
                <div id="log"></div>
            </div>
        </div>
    </div>

    {ignore}
    <script>
        //const emptyEmoji = '⬛';
        const emptyEmoji = ' ';
        // Ігрові змінні
        const player = {
            level: 1,
            health: 20,  // Зменшено стартове здоров'я з 100 до 20
            maxHealth: 20,
            bonusHealth: 0, // Бонусне здоров'я яке додається еліксирами
            baseAttack: 3,  // Зменшено базову атаку
            baseDefense: 2, // Зменшено базовий захист
            gold: 0,
            xp: 0,
            xpToNext: 50,  // Зменшено досвід для першого рівня
            emoji: '🧙‍♂️',
            inventory: [],
            equipment: {
                weapon: null,
                armor: null,
                ring: null,
                amulet: null,
                book: null,
                relic: null
            },
            position: { x: 0, y: 0 },
            get attack() {
                let attack = this.baseAttack;
                if (this.equipment.weapon) attack += this.equipment.weapon.attack;
                if (this.equipment.ring) attack += (this.equipment.ring.attack || 0);
                if (this.equipment.amulet) attack += (this.equipment.amulet.attack || 0);
                if (this.equipment.book) attack += (this.equipment.book.attack || 0);
                if (this.equipment.relic) attack += (this.equipment.relic.attack || 0);
                return attack;
            },
            get defense() {
                let defense = this.baseDefense;
                if (this.equipment.armor) defense += this.equipment.armor.defense;
                if (this.equipment.ring) defense += (this.equipment.ring.defense || 0);
                if (this.equipment.amulet) defense += (this.equipment.amulet.defense || 0);
                if (this.equipment.book) defense += (this.equipment.book.defense || 0);
                if (this.equipment.relic) defense += (this.equipment.relic.defense || 0);
                return defense;
            },
            get maxHealth() {
                let maxHealth = this.bonusHealth + 20 + (this.level - 1) * 5;  // Зменшено приріст здоров'я за рівень
                if (this.equipment.amulet) maxHealth += (this.equipment.amulet.maxHealth || 0);
                if (this.equipment.relic) maxHealth += (this.equipment.relic.maxHealth || 0);
                return maxHealth;
            }
        };

        // перешкоди
        const obstacles = [
            { type: 'tree', emoji: '🌳', color: '#2a5a1a', name: 'Дерево' },
            { type: 'mountain', emoji: '🗻', color: '#aaaaaa', name: 'Гора' }
        ];

        // Оновлена база даних зброї з параметрами критичної шкоди
        const weapons = [
            { name: "Дерев'яний меч", emoji: "🔪", attack: 1, critChance: 0.05, rarity: 1, value: 3, type: "weapon" },
            { name: "Кинджал", emoji: "🔪", attack: 2, critChance: 0.15, rarity: 1, value: 5, type: "weapon" },
            { name: "Булава", emoji: "🏏", attack: 3, critChance: 0.08, rarity: 2, value: 8, type: "weapon" },
            { name: "Сокира", emoji: "🪓", attack: 4, critChance: 0.1, rarity: 2, value: 10, type: "weapon" },
            { name: "Меч", emoji: "⚔️", attack: 5, critChance: 0.1, rarity: 3, value: 15, type: "weapon" },
            { name: "Спис", emoji: "🔱", attack: 6, critChance: 0.12, rarity: 3, value: 18, type: "weapon" },
            { name: "Двосічний меч", emoji: "🗡️", attack: 7, critChance: 0.1, rarity: 4, value: 25, type: "weapon" },
            { name: "Бойовий молот", emoji: "🔨", attack: 8, critChance: 0.07, rarity: 4, value: 30, type: "weapon" },
            { name: "Лук", emoji: "🏹", attack: 6, critChance: 0.2, rarity: 3, value: 20, type: "weapon" },
            { name: "Арбалет", emoji: "🎯", attack: 8, critChance: 0.25, rarity: 4, value: 35, type: "weapon" },
            { name: "Катана", emoji: "🗡", attack: 9, critChance: 0.15, rarity: 5, value: 45, type: "weapon" },
            { name: "Легендарний меч", emoji: "⚔️🌟", attack: 12, critChance: 0.15, rarity: 5, value: 60, type: "weapon" },
            { name: "Міфічний клинок", emoji: "🗡✨", attack: 15, critChance: 0.2, rarity: 6, value: 100, type: "weapon" }
        ];

        // Розширена база даних броні
        const armors = [
            { name: "Шкіряний жилет", emoji: "🧥", defense: 1, rarity: 1, value: 3, type: "armor" },
            { name: "Шкіряна броня", emoji: "🧥", defense: 2, rarity: 1, value: 5, type: "armor" },
            { name: "Кольчуга", emoji: "⛓️", defense: 3, rarity: 2, value: 8, type: "armor" },
            { name: "Латні рукавиці", emoji: "🧤", defense: 1, rarity: 1, value: 4, type: "armor" },
            { name: "Латний шолом", emoji: "⛑️", defense: 2, rarity: 2, value: 6, type: "armor" },
            { name: "Латна броня", emoji: "🛡️", defense: 5, rarity: 3, value: 15, type: "armor" },
            { name: "Міфічна броня", emoji: "👑", defense: 7, rarity: 4, value: 25, type: "armor" },
            { name: "Драконяча шкура", emoji: "🐉", defense: 8, rarity: 4, value: 35, type: "armor" },
            { name: "Легендарна броня", emoji: "🛡️🌟", defense: 10, rarity: 5, value: 50, type: "armor" },
            { name: "Броня архонта", emoji: "🛡✨", defense: 13, rarity: 6, value: 90, type: "armor" }
        ];

        // Розширена база даних артефактів
        const artifacts = [
            // Кільця
            { name: "Мідне кільце", emoji: "💍", attack: 1, rarity: 1, value: 5, type: "ring" },
            { name: "Срібне кільце", emoji: "💍", defense: 1, rarity: 1, value: 5, type: "ring" },
            { name: "Кільце сили", emoji: "💍", attack: 2, rarity: 2, value: 10, type: "ring" },
            { name: "Кільце захисту", emoji: "💍", defense: 2, rarity: 2, value: 10, type: "ring" },
            { name: "Кільце воїна", emoji: "💍", attack: 3, defense: 1, rarity: 3, value: 20, type: "ring" },
            { name: "Кільце мага", emoji: "💍", attack: 1, defense: 3, rarity: 3, value: 20, type: "ring" },
            { name: "Кільце титана", emoji: "💍🌟", attack: 4, defense: 4, rarity: 5, value: 50, type: "ring" },
            { name: "Кільце дракона", emoji: "💍🐉", attack: 5, defense: 3, rarity: 5, value: 60, type: "ring" },
            { name: "Кільце безсмертя", emoji: "💍✨", attack: 3, defense: 5, maxHealth: 10, rarity: 6, value: 80, type: "ring" },
            
            // Амулети
            { name: "Дерев'яний амулет", emoji: "📿", maxHealth: 5, rarity: 1, value: 8, type: "amulet" },
            { name: "Амулет здоров'я", emoji: "📿", maxHealth: 10, rarity: 2, value: 15, type: "amulet" },
            { name: "Амулет воїна", emoji: "📿", attack: 2, maxHealth: 5, rarity: 2, value: 18, type: "amulet" },
            { name: "Амулет мудрості", emoji: "📿", defense: 2, maxHealth: 5, rarity: 2, value: 18, type: "amulet" },
            { name: "Амулет берсерка", emoji: "📿", attack: 4, defense: -1, rarity: 3, value: 25, type: "amulet" },
            { name: "Амулет захисника", emoji: "📿", defense: 4, attack: -1, rarity: 3, value: 25, type: "amulet" },
            { name: "Амулет балансу", emoji: "📿", attack: 2, defense: 2, maxHealth: 10, rarity: 4, value: 40, type: "amulet" },
            { name: "Амулет безсмертя", emoji: "📿🌟", maxHealth: 25, rarity: 5, value: 70, type: "amulet" },
            { name: "Амулет фенікса", emoji: "📿🔥", maxHealth: 30, attack: 3, rarity: 6, value: 100, type: "amulet" },
            
            // Книги
            { name: "Книга початківця", emoji: "📖", attack: 1, defense: 1, rarity: 1, value: 10, type: "book" },
            { name: "Книга мечників", emoji: "📖", attack: 3, rarity: 2, value: 20, type: "book" },
            { name: "Книга захисників", emoji: "📖", defense: 3, rarity: 2, value: 20, type: "book" },
            { name: "Книга знань", emoji: "📖", attack: 2, defense: 2, rarity: 3, value: 30, type: "book" },
            { name: "Книга воєнних мистецтв", emoji: "📖", attack: 5, defense: 1, rarity: 4, value: 50, type: "book" },
            { name: "Книга древніх", emoji: "📖", defense: 5, attack: 1, rarity: 4, value: 50, type: "book" },
            { name: "Заборонений фоліант", emoji: "📖🌟", attack: 5, defense: 5, maxHealth: 15, rarity: 5, value: 100, type: "book" },
            { name: "Книга пророцтв", emoji: "📖🔮", attack: 7, defense: 7, maxHealth: 20, rarity: 6, value: 150, type: "book" },
            
            // Реліквії
            { name: "Святий символ", emoji: "🏆", maxHealth: 10, rarity: 3, value: 30, type: "relic" },
            { name: "Святий грааль", emoji: "🏆", maxHealth: 20, rarity: 4, value: 60, type: "relic" },
            { name: "Кристал влади", emoji: "🏆", attack: 5, rarity: 4, value: 60, type: "relic" },
            { name: "Щит бога", emoji: "🏆", defense: 5, rarity: 4, value: 60, type: "relic" },
            { name: "Око дракона", emoji: "🏆🐉", attack: 7, defense: 3, rarity: 5, value: 90, type: "relic" },
            { name: "Серце дракона", emoji: "🏆🌟", attack: 8, defense: 8, maxHealth: 30, rarity: 5, value: 150, type: "relic" },
            { name: "Корона короля", emoji: "👑", attack: 5, defense: 5, maxHealth: 25, rarity: 6, value: 120, type: "relic" },
            { name: "Сфера всемогутності", emoji: "🔮", attack: 10, defense: 10, maxHealth: 40, rarity: 6, value: 200, type: "relic" }
        ];
        
        // Додаємо еліксири до бази даних предметів
        const potions = [
            { name: "Еліксир сили", emoji: "🧪", type: "potion_attack", description: "⚔️+1", effect: "attack", value: 1, rarity: 2, canSell: false },
            { name: "Еліксир захисту", emoji: "🧪", type: "potion_defense", description: "🛡+1", effect: "defense", value: 1, rarity: 2, canSell: false },
            { name: "Еліксир життя", emoji: "🧪", type: "potion_health", description: "💖+5", effect: "maxHealth", value: 5, rarity: 2, canSell: false }
        ];

        // Здорове харчівництво ;)
        const fruits = [
            { 
                name: "Яблуко", 
                emoji: "🍎", 
                healPercent: 0.25,  // 25% здоров'я
                rarity: 1, 
                type: "fruit",
                color: "#ff5555"  // Червоний
            },
            { 
                name: "Банан", 
                emoji: "🍌",
                healPercent: 0.5,   // 50% здоров'я
                rarity: 2, 
                type: "fruit",
                color: "#ffeb3b"  // Жовтий
            },
            { 
                name: "Виноград", 
                emoji: "🍇", 
                healPercent: 1.0,   // 100% здоров'я
                rarity: 3, 
                type: "fruit",
                color: "#673ab7"  // Фіолетовий
            }
        ];

        // Карта гри
        const mapSize = 10;
        let gameMap = [];
        let enemies = [];
        let visitedCells = new Set();

        // Елементи DOM
        const elements = {
            level: document.getElementById('level'),
            gold: document.getElementById('gold'),
            xp: document.getElementById('xp'),
            xpToNext: document.getElementById('xpToNext'),
            attack: document.getElementById('attack-display'),
            defense: document.getElementById('defense-display'),
            maxHealth: document.getElementById('max-health-display'),
            log: document.getElementById('log'),
            healBtn: document.getElementById('healBtn'),
            resurrectBtn: document.getElementById('resurrectBtn'),
            playerHealthBar: document.getElementById('player-health-bar'),
            playerXpBar: document.getElementById('player-xp-bar'),
            playerView: document.getElementById('player-view'),
            playerEmoji: document.getElementById('player-emoji'),
            enemyHealthBar: document.getElementById('enemy-health-bar'),
            enemyView: document.getElementById('enemy-view'),
            enemyEmoji: document.getElementById('enemy-emoji'),
            enemyStats: document.getElementById('enemy-stats'),
            vs: document.getElementById('vs'),
            inventoryItems: document.getElementById('inventory-items'),
            weaponSlot: document.getElementById('weapon-slot'),
            armorSlot: document.getElementById('armor-slot'),
            ringSlot: document.getElementById('ring-slot'),
            amuletSlot: document.getElementById('amulet-slot'),
            bookSlot: document.getElementById('book-slot'),
            relicSlot: document.getElementById('relic-slot'),
            map: document.getElementById('map')
        };

        // Ініціалізація карти
        function initMap() {
            gameMap = [];
            enemies = [];
            elements.map.innerHTML = '';
            
            for (let y = 0; y < mapSize; y++) {
                gameMap[y] = [];
                for (let x = 0; x < mapSize; x++) {
                    // 15% шанс на перешкоду (дерево або гора)
                    const isObstacle = Math.random() < 0.1;
                    let cellContent;
                    
                    if (isObstacle) {
                        const obstacleType = Math.random() < 0.7 ? 'tree' : 'mountain'; // 70% дерев, 30% гір
                        cellContent = {
                            type: 'obstacle',
                            obstacle: obstacles.find(o => o.type === obstacleType),
                            emoji: obstacleType === 'tree' ? '🌳' : '🗻',
                            passable: false
                        };
                    } else {
                        cellContent = { 
                            type: 'empty',
                            emoji: emptyEmoji,
                            passable: true
                        };
                    }
                    
                    gameMap[y][x] = cellContent;
                    
                    const cell = document.createElement('div');
                    cell.className = 'map-cell';
                    cell.dataset.x = x;
                    cell.dataset.y = y;
                    cell.textContent = cellContent.emoji;
                    
                    cell.addEventListener('click', () => movePlayer(x, y));
                    
                    elements.map.appendChild(cell);
                }
            }
            
            // Початкова позиція гравця
            player.position = { x: Math.floor(mapSize/2), y: Math.floor(mapSize/2) };

            // Додаємо фруктові клітинки при отриманні рівня
            spawnFruits();
            
            // Додаємо ворогів та артефакти на карту
            spawnEnemies();
            spawnArtifacts();
            updateMap();
        }

        // Оновлена функція для відображення ворогів на карті
        function updateMap() {
            const cells = document.querySelectorAll('.map-cell');
            
            visitedCells.add(`${player.position.x},${player.position.y}`);
            
            cells.forEach(cell => {
                const x = parseInt(cell.dataset.x);
                const y = parseInt(cell.dataset.y);
                
                cell.className = 'map-cell';
                cell.textContent = gameMap[y][x].emoji;
                cell.id = '';

                if (gameMap[y][x].type === 'obstacle') {
                    cell.classList.add('obstacle-cell');
                    if (gameMap[y][x].obstacle.type === 'tree') {
                        cell.classList.add('tree-cell');
                    } else {
                        cell.classList.add('mountain-cell');
                    }
                }
                
                if (visitedCells.has(`${x},${y}`)) {
                    cell.classList.add('visited-cell');
                }
                
                if (x === player.position.x && y === player.position.y) {
                    cell.textContent = player.emoji;
                    cell.classList.add('player-cell');
                    cell.id = 'player-on-map';
                    return;
                }
                
                const enemy = enemies.find(e => e.position.x === x && e.position.y === y);
                if (enemy) {
                    cell.textContent = enemy.emoji;
                    
                    if (enemy.boss) cell.classList.add('boss-cell');
                    else if (enemy.elite) cell.classList.add('elite-cell');
                    else if (enemy.abilities.includes('magic')) cell.classList.add('magic-cell');
                    else cell.classList.add('enemy-cell');
                    return;
                }
                
                if (gameMap[y][x].type === 'artifact') {
                    cell.textContent = gameMap[y][x].emoji;
                    if (gameMap[y][x].artifact.type.startsWith('potion')) {
                        cell.classList.add('potion-cell');
                    } else {
                        cell.classList.add('artifact-cell');
                    }
                    return;
                }

                if (gameMap[y][x].type === 'fruit') {
                    cell.textContent = gameMap[y][x].emoji;
                    cell.classList.add('fruit-cell');
                    cell.style.color = gameMap[y][x].color;
                    cell.dataset.fruit = Math.floor(gameMap[y][x].fruit.healPercent * 100);
                    return;
                }
                
                if (visitedCells.has(`${x},${y}`)) {
                    cell.textContent = gameMap[y][x].emoji;
                }
            });
        }

        // Переміщення гравця
        function movePlayer(x, y) {
            if (player.health <= 0) {
                addLog('💀 Ви мертві і не можете рухатись!', 'system');
                return;
            }

            // Перевіряємо чи клітинка є перешкодою
            if (gameMap[y][x].type === 'obstacle') {
                addLog(`🚫 Не можна пройти: ${gameMap[y][x].obstacle.name}!`, 'system');
                return;
            }
            
            // Перевіряємо чи клітинка сусідня
            const dx = Math.abs(x - player.position.x);
            const dy = Math.abs(y - player.position.y);
            
            if (dx > 1 || dy > 1 || (dx === 0 && dy === 0)) {
                addLog('🚫 Ви можете рухатись лише на сусідні клітинки!', 'system');
                return;
            }
            
            // Перевіряємо чи є там ворог
            const enemyIndex = enemies.findIndex(e => e.position.x === x && e.position.y === y);
            if (enemyIndex !== -1) {
                updateEnemyStats(enemies[enemyIndex]);
                elements.enemyEmoji.textContent = enemies[enemyIndex].emoji;
                
                showEnemy(enemies[enemyIndex]);
                setTimeout(function() {
                    startBattle(enemies[enemyIndex]);
                }, 1500);
                return;
            }
            
            // Перевіряємо чи є там артефакт
            if (gameMap[y][x].type === 'artifact') {
                pickUpArtifact(x, y);
                return;
            }
            // Перевіряємо чи є там фрукт
            if (gameMap[y][x].type === 'fruit') {
                pickUpFruit(x, y);
                return;
            }
            
            // Переміщуємо гравця
            player.position = { x, y };
            addLog(`🚶 Ви перейшли на клітинку [${x}, ${y}]`, 'system');
            
            // Перевіряємо чи є тут щось цікаве
            checkCellContent(x, y);
            
            updateMap();
        }

        // Підбираємо артефакт
        function pickUpArtifact(x, y) {
            const artifact = gameMap[y][x].artifact;
            
            // Особливе повідомлення для еліксирів
            if (artifact.type.startsWith('potion')) {
                addLog(`✨ Ви знайшли потужний еліксир: ${artifact.emoji} <strong>${artifact.name}</strong> ⚗️ ${artifact.description}!`, 'artifact', '#4504ed');
            } else {
                let descArt = '';
                if (artifact.attack) descArt = `⚔️ +${artifact.attack} до атаки`;
                if (artifact.defense) descArt = `🛡️ +${artifact.defense} до захисту`;
                if (artifact.maxHealth) descArt = `❤️ +${artifact.maxHealth} до максимального здоров'я`;
                
                addLog(`✨ Ви знайшли артефакт: ${artifact.emoji} <strong>${artifact.name}</strong> ${descArt}!`, 'artifact', '#4504ed');
            }
            
            player.inventory.push(artifact);
            // Видаляємо артефакт з карти
            gameMap[y][x] = { type: 'empty', emoji: emptyEmoji };
            player.position = { x, y };
            
            updateMap();
            updateInventory();
        }

        function pickUpFruit(x, y) {
            const fruit = gameMap[y][x].fruit;
            const healAmount = Math.floor(player.maxHealth * fruit.healPercent);
            const newHealth = Math.min(player.maxHealth, player.health + healAmount);
            const actualHeal = newHealth - player.health;
            
            player.health = newHealth;
            player.position = { x, y };
            
            // Анімація
            showEventPopup(`+${actualHeal}❤️`, document.getElementById('player-on-map'), {
                color: fruit.color,
                fontSize: '24px'
            });
            
            // Повідомлення з відсотком
            let percentText = '';
            if (fruit.healPercent === 0.25) percentText = ' (25%)';
            else if (fruit.healPercent === 0.5) percentText = ' (50%)';
            else percentText = ' (100%)';
            
            addLog(`🍏 Ви з'їли ${fruit.emoji} ${fruit.name} і відновили ${actualHeal} HP${percentText}!`, 'system');
            
            // Видаляємо фрукт з карти
            gameMap[y][x] = { type: 'empty', emoji: emptyEmoji };
            
            updateStats();
            updateMap();
        }

        // Перевіряємо вміст клітинки
        function checkCellContent(x, y) {
            const cell = gameMap[y][x];
            
            if (cell.type === 'treasure') {
                const goldFound = Math.floor(Math.random() * 10 * player.level) + 5;
                player.gold += goldFound;
                addLog(`💰🎁 Ви знайшли скарб і отримали ${goldFound} золота!`, 'loot');
                showEventPopup(`+${goldFound}💰🎁`, document.getElementById('player-on-map'), {
                    color: '#ff0',
                    fontSize: '20px'
                });
                
                // Видаляємо скарб
                gameMap[y][x] = { type: 'empty', emoji: emptyEmoji };
                updateStats();
                updateMap();
            }
        }

        // Додаємо ворогів на карту
        function spawnEnemies() {
            const enemyCount = 5 + player.level;
            
            for (let i = 0; i < enemyCount; i++) {
                let x, y;
                let attempts = 0;

                do {
                    x = Math.floor(Math.random() * mapSize);
                    y = Math.floor(Math.random() * mapSize);

                    attempts++;
                    if (attempts > 100) break; // Захист від нескінченного циклу
                } while (
                    (x === player.position.x && y === player.position.y) ||
                    enemies.some(e => e.position.x === x && e.position.y === y) ||
                    gameMap[y][x].type !== 'empty'
                );

                if (attempts <= 100) {
                    const enemy = generateEnemy();
                    enemy.position = { x, y };
                    enemies.push(enemy);
                }
            }
        }

        // Додаємо артефакти на карту
        function spawnArtifacts() {
            const artifactCount = 2 + Math.floor(player.level / 3);
            
            for (let i = 0; i < artifactCount; i++) {
                let x, y;
                let attempts = 0;

                do {
                    x = Math.floor(Math.random() * mapSize);
                    y = Math.floor(Math.random() * mapSize);

                    attempts++;
                    if (attempts > 100) break; // Захист від нескінченного циклу
                } while (
                    (x === player.position.x && y === player.position.y) ||
                    enemies.some(e => e.position.x === x && e.position.y === y) ||
                    gameMap[y][x].type !== 'empty'
                );
                
                if (attempts <= 100) {
                    const artifact = generateArtifact();
                    gameMap[y][x] = {
                        type: 'artifact',
                        emoji: artifact.emoji,
                        artifact: artifact
                    };
                }
            }
            
            // Додаємо скарби
            for (let i = 0; i < 3; i++) {
                let x, y;
                let attempts = 0;

                do {
                    x = Math.floor(Math.random() * mapSize);
                    y = Math.floor(Math.random() * mapSize);

                    attempts++;
                    if (attempts > 100) break; // Захист від нескінченного циклу
                } while (
                    (x === player.position.x && y === player.position.y) ||
                    enemies.some(e => e.position.x === x && e.position.y === y) ||
                    gameMap[y][x].type !== 'empty'
                );
                
                if (attempts <= 100) {
                    gameMap[y][x] = { type: 'treasure', emoji: '💰' };
                }
            }
            
            updateMap();
        }

        function spawnFruits() {
            // Кількість фруктів залежить від рівня
            const fruitCount = 2 + Math.floor(player.level / 3);
            
            for (let i = 0; i < fruitCount; i++) {
                let x, y;
                let attempts = 0;

                do {
                    x = Math.floor(Math.random() * mapSize);
                    y = Math.floor(Math.random() * mapSize);

                    attempts++;
                    if (attempts > 100) break; // Захист від нескінченного циклу
                } while (
                    (x === player.position.x && y === player.position.y) ||
                    enemies.some(e => e.position.x === x && e.position.y === y) ||
                    gameMap[y][x].type !== 'empty'
                );
                
                if (attempts <= 100) {
                    // Вибираємо фрукт з урахуванням рідкості (вищі рівні - кращі фрукти)
                    const rarityRoll = Math.random();
                    let fruitType;
                    
                    if (rarityRoll > 0.9 && player.level > 3) {       // 10% шанс на виноград (рівень > 3)
                        fruitType = fruits.find(f => f.healPercent === 1.0);
                    } else if (rarityRoll > 0.6) {                   // 30% шанс на банан
                        fruitType = fruits.find(f => f.healPercent === 0.5);
                    } else {                                         // 60% шанс на яблуко
                        fruitType = fruits.find(f => f.healPercent === 0.25);
                    }
                    
                    gameMap[y][x] = {
                        type: 'fruit',
                        emoji: fruitType.emoji,
                        fruit: fruitType,
                        color: fruitType.color  // Зберігаємо колір для анімації
                    };
                }
            }
            
            addLog(`🍇 На карті з'явились корисні фрукти! Вони відновлять відсоток вашого здоров'я.`, 'system');
            updateMap();
        }

        function respawnObstacles() {
            // Видаляємо 20-30% старих перешкод
            for (let y = 0; y < mapSize; y++) {
                for (let x = 0; x < mapSize; x++) {
                    if (gameMap[y][x].type === 'obstacle' && Math.random() < 0.25) {
                        gameMap[y][x] = { 
                            type: 'empty',
                            emoji: emptyEmoji,
                            passable: true
                        };
                    }
                }
            }
            
            // Додаємо нові перешкоди
            const newObstacles = Math.floor(mapSize * mapSize * 0.07); // 7% клітинок
            for (let i = 0; i < newObstacles; i++) {
                let x, y;
                let attempts = 0;
                do {
                    x = Math.floor(Math.random() * mapSize);
                    y = Math.floor(Math.random() * mapSize);
                    attempts++;
                    if (attempts > 100) break;
                } while (
                    (x === player.position.x && y === player.position.y) ||
                    enemies.some(e => e.position.x === x && e.position.y === y) ||
                    gameMap[y][x].type !== 'empty'
                );
                
                if (attempts <= 100) {
                    const obstacleType = Math.random() < 0.7 ? 'tree' : 'mountain';
                    gameMap[y][x] = {
                        type: 'obstacle',
                        obstacle: obstacles.find(o => o.type === obstacleType),
                        emoji: obstacleType === 'tree' ? '🌳' : '🗻',
                        passable: false
                    };
                }
            }
        }

        // Функція для показу повідомлення
        function showGameMessage(message, duration = 0) {
            const modal = document.getElementById('game-modal');
            const messageElement = document.getElementById('modal-message');
            const okButton = document.getElementById('modal-ok');
            
            messageElement.innerHTML = message;
            modal.style.display = 'block';
            
            // Обробник кнопки OK
            okButton.onclick = function() {
                modal.style.display = 'none';
            }
            
            // Автозакриття через вказаний час (якщо duration > 0)
            if (duration > 0) {
                setTimeout(() => {
                    modal.style.display = 'none';
                }, duration);
            }
            
            // Закриття при кліку поза вікном
            window.onclick = function(event) {
                if (event.target == modal) {
                    modal.style.display = 'none';
                }
            }
        }

        // Додаємо повідомлення до журналу
        function addLog(message, type = 'system', alertColor = 'rgba(255, 255, 255, 0)') {
            const logEntry = document.createElement('div');
            alertColor = typeof alertColor != undefined ? alertColor : false;
            logEntry.innerHTML = message;
            logEntry.className = type;
            if (alertColor) {
                logEntry.style.backgroundColor = alertColor;
            }

            // видаляємо старіші записи з логу
            if (elements.log.children.length > 300) {
                while (elements.log.children.length > 50) {
                    elements.log.removeChild(elements.log.firstChild);
                }
            }

            elements.log.appendChild(logEntry);
            elements.log.scrollTop = elements.log.scrollHeight;
        }

        // функція розрахунку досвіду для рівня
        function getXpByLevel(level) {
            const baseXp = 50;
            const growthRate = 1.5;
            const rawXp = baseXp * Math.pow(growthRate, level - 1);

            // Автоматичне округлення до приємного масштабу
            let roundingStep = 10;
            if (rawXp >= 1000) {
                roundingStep = Math.pow(10, Math.floor(Math.log10(rawXp)));
                if (rawXp < roundingStep * 2) roundingStep /= 10;
            }

            return Math.round(rawXp / roundingStep) * roundingStep;
        }

        // Оновлюємо статистику гравця на екрані
        function updateStats() {
            elements.level.textContent = player.level;
            elements.gold.textContent = player.gold;
            elements.xp.textContent = player.xp;
            elements.xpToNext.textContent = player.xpToNext;
            elements.attack.textContent = player.attack;
            elements.defense.textContent = player.defense;
            elements.maxHealth.textContent = player.health + '/' + player.maxHealth;
            
            // Оновлюємо health bar гравця
            const playerHealthPercent = (player.health / player.maxHealth) * 100;
            elements.playerHealthBar.style.width = `${playerHealthPercent}%`;
            
            // Оновлюємо xp bar гравця
            const playerXpPercent = (player.xp / player.xpToNext) * 100;
            elements.playerXpBar.style.width = `${playerXpPercent}%`;
        }

        // Оновлюємо інвентар
        function updateInventory() {
            elements.inventoryItems.innerHTML = '';
            
            // Обладнання
            updateEquipmentSlot('weapon');
            updateEquipmentSlot('armor');
            updateEquipmentSlot('ring');
            updateEquipmentSlot('amulet');
            updateEquipmentSlot('book');
            updateEquipmentSlot('relic');
            
            // Інвентар
            player.inventory.forEach((item, index) => {
                const itemElement = document.createElement('div');
                itemElement.className = 'item-slot';
                
                // Визначаємо клас для еліксирів
                let itemClass = '';
                if (item.type === 'potion_health') itemClass = 'potion-health';
                else if (item.type === 'potion_attack') itemClass = 'potion-attack';
                else if (item.type === 'potion_defense') itemClass = 'potion-defense';
                
                let bonusText = '';
                if (item.attack) bonusText += ` ⚔️+${item.attack}`;
                if (item.defense) bonusText += ` 🛡️+${item.defense}`;
                if (item.maxHealth) bonusText += ` ❤️+${item.maxHealth}`;
                if (item.description) bonusText = ` ${item.description}`;
                
                itemElement.innerHTML = `
                    <span class="${itemClass}">${item.emoji} ${item.name}</span><span class="artifact-bonus">${bonusText}</span>
                    <div class="item-actions">
                        <div class="item-action" onclick="useItem(${index})">${item.type.startsWith('potion') ? 'Випити' : 'Екіпірувати'}</div>
                        ${item.canSell !== false ? `<div class="item-action" onclick="sellItem(${index})">Продати (${Math.floor(item.value * 0.7)}💰)</div>` : ''}
                    </div>
                `;
                
                elements.inventoryItems.appendChild(itemElement);
            });
            
            if (player.inventory.length === 0) {
                elements.inventoryItems.innerHTML = '<p>Інвентар порожній</p>';
            }
        }

        // Оновлюємо слот обладнання
        function updateEquipmentSlot(slot) {
            const element = elements[`${slot}Slot`];
            if (player.equipment[slot]) {
                const item = player.equipment[slot];
                let bonusText = '';
                if (item.attack) bonusText += ` ⚔️+${item.attack}`;
                if (item.defense) bonusText += ` 🛡️+${item.defense}`;
                if (item.maxHealth) bonusText += ` ❤️+${item.maxHealth}`;
                
                element.innerHTML = `${item.emoji} ${item.name}<span class="artifact-bonus">${bonusText}</span>`;
            } else {
                element.textContent = 'Пусто';
            }
        }

        // Екіпіруємо предмет
        function equipItem(index) {
            const item = player.inventory[index];
            let slot = item.type;
            
            // Якщо цей тип предмета вже екіпіровано, додаємо його в інвентар
            if (player.equipment[slot]) {
                player.inventory.push(player.equipment[slot]);
            }
            
            // Екіпіруємо новий предмет
            player.equipment[slot] = item;
            
            // Видаляємо предмет з інвентаря
            player.inventory.splice(index, 1);
            
            // Оновлюємо здоров'я, якщо змінилось максимальне значення
            if (item.maxHealth) {
                //player.health += item.maxHealth;
                //player.health = Math.min(player.health, player.maxHealth);
            }
            
            addLog(`✨ Ви екіпірували ${item.emoji} <strong>${item.name}</strong>!`, 'artifact');
            if (item.attack) addLog(`⚔️ +${item.attack} до атаки`, 'artifact');
            if (item.defense) addLog(`🛡️ +${item.defense} до захисту`, 'artifact');
            if (item.maxHealth) addLog(`❤️ +${item.maxHealth} до максимального здоров'я`, 'artifact');
            
            updateStats();
            updateInventory();
        }

        // Продаємо предмет
        function sellItem(index) {
            const item = player.inventory[index];
            
            // Еліксири не можна продавати
            if (item.canSell === false) {
                addLog(`⚠️ ${item.emoji} ${item.name} не можна продати!`, 'system');
                return;
            }

            const sellPrice = Math.floor(item.value * 0.7); // Продаємо за 70% вартості
            
            player.gold += sellPrice;
            player.inventory.splice(index, 1);
            
            addLog(`💰 Ви продали ${item.emoji} ${item.name} за ${sellPrice} золота`, 'sell');
            // сповіщення продажу
            showEventPopup(`+${sellPrice}💰`, document.getElementById('player-on-map'), {
                color: '#ff0',
                fontSize: '20px'
            });
            updateStats();
            updateInventory();
        }

        // Генеруємо випадковий предмет
        function generateItem() {
            // 60% шанс отримати предмет
            if (Math.random() > 0.6) return null;
            
            // Вибираємо тип предмета (зброя, броня чи артефакт)
            const itemTypeRoll = Math.random();
            let itemPool;
            
            // 0-40% - weapons 41-75% - armors 76-90% - potions 91-100% - artifacts
            if (itemTypeRoll < 0.4) itemPool = weapons;
            else if (itemTypeRoll < 0.75) itemPool = armors;
            else if (itemTypeRoll < 0.9) itemPool = potions;
            else itemPool = artifacts;
            
            // Визначаємо рідкість на основі рівня гравця
            let rarity = 1;
            const rarityRoll = Math.random();
            
            if (rarityRoll > 0.95) rarity = 5; // 5% шанс на легендарний
            else if (rarityRoll > 0.85) rarity = 4; // 10% шанс на міфічний
            else if (rarityRoll > 0.65) rarity = 3; // 20% шанс на рідкісний
            else if (rarityRoll > 0.4) rarity = 2; // 25% шанс на звичайний
            else rarity = 1; // 40% шанс на поширений
            
            // Фільтруємо предмети за рідкістю
            const availableItems = itemPool.filter(item => item.rarity <= rarity);
            
            if (availableItems.length === 0) return null;
            
            // Вибираємо випадковий предмет з доступних
            const itemTemplate = availableItems[Math.floor(Math.random() * availableItems.length)];
            
            // Створюємо копію предмета для гравця
            return {
                ...itemTemplate,
                id: Date.now() + Math.floor(Math.random() * 1000)
            };
        }
        
        // Оновлюємо функцію для використання предметів
        function useItem(index) {
            const item = player.inventory[index];
            
            if (item.type === 'potion_attack') {
                player.baseAttack += item.value;
                addLog(`🧪 Ви випили ${item.emoji} ${item.name}! Ваша атака збільшилась на ${item.value}.`, 'system');
                updateStats();
            }
            else if (item.type === 'potion_defense') {
                player.baseDefense += item.value;
                addLog(`🧪 Ви випили ${item.emoji} ${item.name}! Ваш захист збільшився на ${item.value}.`, 'system');
                updateStats();
            }
            else if (item.type === 'potion_health') {
                player.bonusHealth += item.value;
                player.health += item.value;
                addLog(`🧪 Ви випили ${item.emoji} ${item.name}! Ваше максимальне здоров'я збільшилось на ${item.value}.`, 'system');
                updateStats();
            } else {
                // Якщо це не еліксир, екіпіруємо як звичайний предмет
                equipItem(index);
                return;
            }

            if (['potion_attack', 'potion_defense', 'potion_health'].includes(item.type)) {
                showEventPopup(`${item.description}`, document.getElementById('player-on-map'), {
                    color: '#f00',
                });
            }
            
            // Видаляємо еліксир з інвентаря
            player.inventory.splice(index, 1);
            updateInventory();
        }

        // Генеруємо випадковий артефакт
        function generateArtifact() {
            // Визначаємо рідкість на основі рівня гравця
            let rarity = 1;
            const rarityRoll = Math.random();
            
            if (rarityRoll > 0.95) rarity = 5; // 5% шанс на легендарний
            else if (rarityRoll > 0.85) rarity = 4; // 10% шанс на міфічний
            else if (rarityRoll > 0.65) rarity = 3; // 20% шанс на рідкісний
            else if (rarityRoll > 0.4) rarity = 2; // 25% шанс на звичайний
            else rarity = 1; // 40% шанс на поширений
            
            // Фільтруємо артефакти і зілля за рідкістю
            let items = [...artifacts, ...potions];
            
            const availableArtifacts = items.filter(item => item.rarity <= rarity);
            
            if (availableArtifacts.length === 0) return null;
            
            // Вибираємо випадковий артефакт з доступних
            const artifactTemplate = availableArtifacts[Math.floor(Math.random() * availableArtifacts.length)];
            
            // Створюємо копію артефакта для гравця
            return {
                ...artifactTemplate,
                id: Date.now() + Math.floor(Math.random() * 1000)
            };
        }

        // Розширена база даних монстрів
        function generateEnemy() {
            const enemyTypes = [
                // Звичайні монстри
                { type: 'Гоблін', emoji: '👺', color: '#5f5', abilities: [] },
                { type: 'Скелет', emoji: '💀', color: '#fff', abilities: ['undead', 'disease'] },
                { type: 'Вовк', emoji: '🐕', color: '#aaa', abilities: ['fast', 'predator'] },
                { type: 'Павук', emoji: '🕷️', color: '#8b4513', abilities: ['poison'] },
                { type: 'Щур', emoji: '🐀', color: '#808080', abilities: ['disease'] },
                { type: 'Зомбі', emoji: '🧟', color: '#5a5', abilities: ['undead', 'tough', 'disease'] },
                { type: 'Привид', emoji: '👻', color: '#aaf', abilities: ['undead', 'magic_resist'] },
                { type: 'Гарпія', emoji: '🦅', color: '#add8e6', abilities: ['flying', 'fast'] },
                { type: 'Кобольд', emoji: '🦎', color: '#ff6347', abilities: ['trap_master'] },
                
                // Елітні монстри
                { type: 'Орк-воїн', emoji: '👹', color: '#f55', abilities: ['strong', 'tough'], elite: true },
                { type: 'Троль', emoji: '🤢', color: '#228b22', abilities: ['regeneration', 'tough'], elite: true },
                { type: 'Варґ', emoji: '🐺', color: '#4b0082', abilities: ['predator', 'fast'], elite: true },
                { type: 'Вампір', emoji: '🧛', color: '#00ffff', abilities: ['undead', 'bloodsucker', 'magic_resist'], elite: true },
                { type: 'Демон', emoji: '😈', color: '#ff0000', abilities: ['fire_aura', 'magic_resist'], elite: true },
                
                // Боси
                { type: 'Дракон', emoji: '🐉', color: '#f33', abilities: ['fire_breath', 'flying', 'tough'], boss: true },
                { type: 'Гарбузоголовий', emoji: '🎃', color: '#800080', abilities: ['strong', 'tough', 'stomp'], boss: true },
                { type: 'Архідемон', emoji: '🤬', color: '#8b0000', abilities: ['fire_aura', 'bloodsucker', 'fear'], boss: true },
                { type: 'Королева павуків', emoji: '🕸️', color: '#000000', abilities: ['poison', 'web', 'summon'], boss: true }
            ];
            
            // Визначаємо тип ворога залежно від рівня гравця
            let enemyPool = enemyTypes;
            if (player.level < 3) {
                enemyPool = enemyTypes.filter(e => !e.elite && !e.boss);
            } else if (player.level < 5) {
                enemyPool = enemyTypes.filter(e => !e.boss);
            }
            
            // Шанс на елітного ворога
            let isElite = Math.random() < 0.1 + player.level * 0.02;
            if (isElite) {
                enemyPool = enemyTypes.filter(e => e.elite && !e.boss);
            }
            
            // Шанс на боса (рідкісний)
            let isBoss = !isElite && Math.random() < 0.03 + player.level * 0.005;
            if (isBoss) {
                enemyPool = enemyTypes.filter(e => e.boss);
            }
            
            const enemyTemplate = enemyPool[Math.floor(Math.random() * enemyPool.length)];
            const enemy = {...enemyTemplate};
            
            // Базова сила ворога залежить від рівня гравця
            const basePower = 2 + player.level;
            let powerMultiplier = 1.7;
            
            if (enemy.elite) powerMultiplier = 2.6;
            if (enemy.boss) powerMultiplier = 3.5;
            
            // Характеристики ворога
            enemy.health = Math.floor(basePower * powerMultiplier * (0.8 + Math.random() * 0.4));
            
            // Атака та захист з урахуванням здібностей
            enemy.attack = Math.floor(basePower * powerMultiplier * (0.5 + Math.random() * 0.5));
            enemy.defense = Math.floor(basePower * powerMultiplier * (0.3 + Math.random() * 0.4));
            
            // Бонуси від здібностей
            if (enemy.abilities.includes('strong')) enemy.attack += 2;
            if (enemy.abilities.includes('tough')) {
                enemy.defense += 2;
                enemy.health = Math.floor(enemy.health * 1.3);
            }
            if (enemy.abilities.includes('magic_resist')) enemy.defense += 1;
            
            enemy.maxHealth = enemy.health;
            
            // Нагороди
            enemy.gold = Math.floor(basePower * powerMultiplier * (0.5 + Math.random() * 1));
            enemy.xp = Math.floor(basePower * powerMultiplier * (0.8 + Math.random() * 0.8));
            
            if (enemy.elite) {
                enemy.gold = Math.floor(enemy.gold * 1.5);
                enemy.xp = Math.floor(enemy.xp * 1.5);
            }
            if (enemy.boss) {
                enemy.gold = Math.floor(enemy.gold * 3);
                enemy.xp = Math.floor(enemy.xp * 3);
            }
            
            // Ворог може мати предмет (частіше для елітних і босів)
            let itemChance = 0.3;
            if (enemy.elite) itemChance = 0.6;
            if (enemy.boss) itemChance = 0.9;
            
            if (Math.random() < itemChance) {
                enemy.item = generateItem(enemy.boss ? 3 : enemy.elite ? 2 : 1);
            }
            
            return enemy;
        }
        
        function animateAttack(targetEmoji, targetView) {
            targetEmoji.classList.add('shake');
            targetView.classList.add('flash-red');
            setTimeout(() => {
                targetEmoji.classList.remove('shake');
                targetView.classList.remove('flash-red');
            }, 400);
        }
        
        // Універсальна функція для відображення анімації подій з підтримкою затримки
        function showEventPopup(text, targetElement, options = {}) {
            // Значення за замовчуванням
            const defaultOptions = {
                color: '#fff',
                fontSize: '24px',
                isCritical: false,
                delay: 0,  // Затримка в мілісекундах (0 - без затримки)
                popupType: 'normal', // Час існування сповіщення ('normal' - 1s, 'slow' - 3s)
                horizontalOffset: 0, // Зсув точки спавна в px
            };
            
            // Об'єднуємо передані параметри з параметрами за замовчуванням
            options = { ...defaultOptions, ...options };
            
            // Функція, яка фактично створює і показує попап
            const createPopup = () => {
                const popupElement = document.createElement('div');
                popupElement.className = options.popupType == 'slow' ? 'event-popup-slow' : 'event-popup';
                popupElement.textContent = text;
                
                // Застосовуємо стилі
                popupElement.style.color = options.color;
                popupElement.style.fontSize = options.fontSize;
                
                if (options.isCritical) {
                    popupElement.textContent += '💥';
                    popupElement.style.fontWeight = 'bold';
                    popupElement.style.textShadow = '0 0 5px gold';
                }
                
                // Позиціонування
                const rect = targetElement.getBoundingClientRect();
                popupElement.style.position = 'absolute';
                popupElement.style.left = `${options.horizontalOffset + rect.left + rect.width/2 - 20}px`;
                popupElement.style.top = `${rect.top - 20}px`;
                popupElement.style.zIndex = '1000';
                popupElement.style.pointerEvents = 'none';
                popupElement.style.animation = 'popup 1s forwards';
                
                document.body.appendChild(popupElement);
                
                // Видалення елемента після анімації
                setTimeout(() => {
                    popupElement.remove();
                }, options.popupType == 'slow' ? 3000 : 1000);
            };
            
            // Викликаємо створення попапу з затримкою або без
            if (options.delay > 0) {
                setTimeout(createPopup, options.delay);
            } else {
                createPopup();
            }
        }

        // Оновлена функція для битви з урахуванням здібностей монстрів
        function startBattle(enemy) {
            let fastEnemyStatus = enemy.abilities.includes('fast');
            let iteration = 0;

            // Функція для анімації бою з урахуванням здібностей
            function battleStep() {
                if (player.health <= 0 || enemy.health <= 0) return;
                iteration++;
                
                // Атака гравця
                let playerDamage = player.attack + Math.floor(Math.random() * 5) - 2;
                // для тестів
                    let minDmg = player.attack + Math.floor(0 * 5) - 2;
                    let maxDmg = player.attack + Math.floor(1 * 5) - 2;
                let isCritical = false;
                let critMessage = '';
                let effectiveDefense = enemy.defense;
                
                // Перевірка на критичний удар
                if (player.equipment.weapon && Math.random() < player.equipment.weapon.critChance) {
                    isCritical = true;
                    effectiveDefense = Math.floor(enemy.defense * 0.3); // Ігноруємо 70% захисту
                    critMessage = ` <span class="critical-hit">(КРИТИЧНИЙ УДАР! Ігнорує ${Math.ceil(enemy.defense * 0.7)}🛡️)</span>`;
                }
                
                // тести
                /*console.log([
                    'x: ' + Math.max(1, minDmg - enemy.defense) + '-' + Math.max(1, maxDmg - enemy.defense),
                    'kx: ' + Math.max(1, minDmg - Math.floor(enemy.defense * 0.3)) + '-' + Math.max(1, maxDmg - Math.floor(enemy.defense * 0.3))
                ]);*/
                
                playerDamage = Math.max(1, playerDamage - effectiveDefense);
                
                // Модифікатори від здібностей ворога
                if (enemy.abilities.includes('flying') && Math.random() < 0.25) {
                    addLog(`🦅 ${enemy.emoji} ${enemy.type} ухилився від вашої атаки!`, 'enemy');
                    showEventPopup(`💨`, elements.enemyEmoji, {
                        color: '#f00',
                    });
                    playerDamage = 0;
                }
                
                // Хвороба знижує атаку на 75% але лише не критичні
                if (!isCritical && enemy.abilities.includes('disease') && Math.random() < 0.3) {
                    addLog(`🤢 ${enemy.emoji} ${enemy.type} послабив вашу атаку хворобою!`, 'enemy', '#124f12');
                    showEventPopup(`🤢`, elements.enemyEmoji, {
                        color: '#f00',
                        horizontalOffset: -30
                    });
                    playerDamage = Math.max(1, Math.round(playerDamage * 0.25));
                }
                
                // магічний супротив монстра, але не менше за 1
                if (enemy.abilities.includes('magic_resist')) {
                    playerDamage = Math.max(1, Math.floor(playerDamage * 0.8));
                }
                
                // якщо монстр швидкий, то атакує перший
                if (!fastEnemyStatus) {
                    enemy.health -= playerDamage;
                    
                    animateAttack(elements.enemyEmoji, elements.enemyView);
                    updateEnemyStats(enemy);
                    
                    // Показуємо анімацію шкоди
                    if (playerDamage > 0) {
                        //showDamage(playerDamage, elements.enemyEmoji, isCritical);
                        showEventPopup(`-${playerDamage}`, elements.enemyEmoji, {
                            color: '#f00',
                            isCritical: isCritical
                        });
                        
                        addLog(`[${iteration}] 🗡️ Ви атакуєте ${enemy.emoji} ${enemy.type} і завдаєте ${playerDamage} шкоди.${critMessage}`, 'player', isCritical ? '#8b0303' : 'rgba(255, 255, 255, 0)');
                    }
                } else {
                    fastEnemyStatus = false;
                }

                // Перевірка на перемогу
                if (enemy.health <= 0) {
                    let victoryMessage = `🎉 Ви перемогли ${enemy.emoji} ${enemy.type}!`;
                    if (enemy.boss) victoryMessage = `🏆 ВИ ПЕРЕМОГЛИ БОССА: ${enemy.type} 🎊`;
                    else if (enemy.elite) victoryMessage = `⭐ Ви перемогли елітного ${enemy.type}!`;
                    
                    addLog(victoryMessage, 'system');
                    updateEnemyStats(enemy);
                    
                    // Нагорода
                    player.gold += enemy.gold;
                    player.xp += enemy.xp;
                    addLog(`💰 Ви отримали ${enemy.gold} золота і ${enemy.xp} досвіду.`, 'loot');
                    
                    showEventPopup(`+${enemy.gold}💰`, document.getElementById('player-on-map'), {
                        color: '#ff0',
                        fontSize: '20px',
                        delay: 500,
                        horizontalOffset: -25
                    });
                    showEventPopup(`+${enemy.xp}📈`, document.getElementById('player-on-map'), {
                        color: '#88f',
                        fontSize: '18px',
                        delay: 750,
                        horizontalOffset: 15
                    });
                    
                    // Перевірка на предмет
                    if (enemy.item) {
                        player.inventory.push(enemy.item);
                        addLog(`🎁 ${enemy.item.emoji} Ви отримали: <strong>${enemy.item.name}</strong>!`, 'item', '#4504ed');
                        updateInventory();
                    }
                    
                    // Видаляємо ворога з карти
                    const enemyIndex = enemies.findIndex(e => 
                        e.position.x === enemy.position.x && 
                        e.position.y === enemy.position.y
                    );
                    if (enemyIndex !== -1) {
                        enemies.splice(enemyIndex, 1);
                    }
                    
                    if (enemies.length < 1) {
                        spawnEnemies();
                    }
                    
                    // Перевірка на новий рівень
                    if (checkLevelUp()) {
                        //setTimeout(hideEnemy, 1500);
                    } else {
                        //setTimeout(hideEnemy, 1500);
                    }
                    addLog(`---------------`, 'enemy');
                    
                    updateStats();
                    updateMap();
                    return;
                }

                // Ворог атакує (з урахуванням здібностей)
                setTimeout(() => {
                    let enemyDamage = Math.max(1, enemy.attack - player.defense + Math.floor(Math.random() * 5) - 2);
                    
                    // Спеціальні атаки
                    if (enemy.abilities.includes('strong') && Math.random() < 0.5) {
                        enemyDamage = Math.floor(enemyDamage * 1.3);
                        showEventPopup(`💪`, elements.playerEmoji, {
                            color: '#f00',
                            horizontalOffset: 25
                        });
                    }
                    if (enemy.abilities.includes('fire_breath') && Math.random() < 0.25) {
                        const fireDamage = Math.floor(enemyDamage * 0.5);
                        enemyDamage += fireDamage;
                        showEventPopup(`+${fireDamage}🔥`, elements.enemyEmoji, {
                            color: '#f00',
                            delay: 200,
                            horizontalOffset: 25
                        });
                        addLog(`[${iteration}] 🔥 ${enemy.emoji} ${enemy.type} використовує вогняне дихання (+${fireDamage} шкоди)!`, 'enemy');
                    }
                    if (enemy.abilities.includes('poison') && Math.random() < 0.3) {
                        const poisonDamage = Math.floor(enemyDamage * 0.3);
                        enemyDamage += poisonDamage;
                        addLog(`[${iteration}] ☠️ ${enemy.emoji} ${enemy.type} отруює вас (+${poisonDamage} шкоди)!`, 'enemy');
                    }
                    if (enemy.abilities.includes('bloodsucker') && Math.random() < 0.3) {
                        const suckDamage = Math.max(1, Math.floor(enemyDamage * 0.333));
                        player.health -= suckDamage;
                        enemy.health = Math.min(enemy.maxHealth, enemy.health + suckDamage);
                        showEventPopup(`+${suckDamage}🩸`, elements.enemyEmoji, {
                            color: '#f00',
                            delay: 50,
                        });
                        addLog(`[${iteration}] 🩸 ${enemy.emoji} ${enemy.type} п'є Вашу кров (-${suckDamage} життя)!`, 'enemy', '#470505');
                        updateEnemyStats(enemy);
                    }
                    
                    player.health -= enemyDamage;
                    
                    if (enemyDamage > 0) {
                        showEventPopup(`-${enemyDamage}`, elements.playerEmoji, {
                            color: '#f00',
                        });
                    }
                    
                    animateAttack(elements.playerEmoji, elements.playerView);
                    
                    // Регенерація ворога
                    if (enemy.abilities.includes('regeneration') && Math.random() < 0.5) {
                        const healAmount = Math.floor(enemy.maxHealth * 0.1);
                        enemy.health = Math.min(enemy.maxHealth, enemy.health + healAmount);
                        showEventPopup(`+${healAmount}💚`, elements.enemyEmoji, {
                            color: '#0f0',
                            delay: 200,
                            horizontalOffset: 25
                        });
                        addLog(`💚 ${enemy.emoji} ${enemy.type} відновлює ${healAmount} здоров'я!`, 'enemy');
                        updateEnemyStats(enemy);
                    }
                    
                    // Оновлюємо health bar гравця
                    const playerHealthPercent = Math.max(0, (player.health / player.maxHealth) * 100);
                    elements.playerHealthBar.style.width = `${playerHealthPercent}%`;
                    
                    // Хижак
                    if (enemy.abilities.includes('predator') && Math.random() < 0.3) {
                        player.health -= enemyDamage;
                        showEventPopup(`-${enemyDamage}`, elements.playerEmoji, {
                            color: '#f00',
                            delay: 200,
                            horizontalOffset: 25
                        });
                        addLog(`[${iteration}] 💥 ${enemy.emoji} ${enemy.type} атакує вас двічі і завдає ${enemyDamage} x 2 шкоди.`, 'enemy', 'black');
                    } else {
                        addLog(`[${iteration}] 💥 ${enemy.emoji} ${enemy.type} атакує вас і завдає ${enemyDamage} шкоди.`, 'enemy');
                    }

                    updateStats();

                    // Гравець - мрець
                    if (player.health <= 0) {
                        elements.resurrectBtn.style.display = 'inline-block';
                        addLog('💀 Ви загинули в бою з ${enemy.emoji} ${enemy.type}!', 'system');
                        showGameMessage('💀 Ви загинули в бою! Натисніть "Воскреснути", щоб продовжити гру.', 0);

                        showEventPopup(`💀`, document.getElementById('player-on-map'), {
                            fontSize: '40px',
                        });
                        return;
                    }
                    
                    // Продовжуємо бій
                    setTimeout(battleStep, 1000);
                }, 1000);
            }
            
            // Починаємо бій
            battleStep();
        }

        // Показуємо ворога
        function showEnemy(enemy) {
            elements.enemyView.style.display = 'block';
            elements.enemyEmoji.textContent = enemy.emoji;
            elements.enemyEmoji.style.color = enemy.color;
            
            updateEnemyStats(enemy);
            
            let enemyTitle = enemy.type;
            if (enemy.boss) enemyTitle = `БОС: ${enemy.type} 💀`;
            else if (enemy.elite) enemyTitle = `Елітний ${enemy.type} ⚡`;
            
            addLog(`---------------`, 'enemy');
            addLog(`⚔️ Ви зустріли ${enemy.emoji} <strong>${enemyTitle}</strong> 🗡:${enemy.attack} | 🛡:${enemy.defense} | ❤:${enemy.maxHealth} !`, 'enemy');
            
            // Опис здібностей ворога
            if (enemy.abilities.length > 0) {
                const abilitiesText = enemy.abilities.map(ability => {
                    const abilitiesDesc = {
                        'undead': 'Нежить: невразливий до отрут',
                        'fast': 'Швидкий: атакує першим',
                        'poison': 'Отрута: завдає додаткової шкоди',
                        'disease': 'Хвороба: знижує вашу атаку',
                        'tough': 'Міцний: більше здоров\'я',
                        'magic_resist': 'Магічний опір: знижує вашу атаку',
                        'flying': 'Літає: ухиляється від атак',
                        'trap_master': 'Мастер пасток: може ставити пастки',
                        'strong': 'Сильний: більше атаки',
                        'regeneration': 'Регенерація: лікується кожен хід',
                        'predator': 'Хижак: може атакувати двічі',
                        'bloodsucker': 'Кровопивця',
                        'fire_aura': 'Вогняна аура: палить вас',
                        'fire_breath': 'Вогняне дихання: потужна атака',
                        'stomp': 'Топотіння: оглушає вас',
                        'fear': 'Страх: знижує ваш захист',
                        'web': 'Павутина: знижує вашу швидкість',
                        'summon': 'Покликання: створює мінорів'
                    };
                    return abilitiesDesc[ability] || ability;
                }).join(', ');
                
                addLog(`🔮 Здібності: ${abilitiesText}`, 'enemy');
            }
        }
        
        function updateEnemyStats(enemy) {
            elements.enemyStats.textContent = `АТК: ${enemy.attack} | ЗАХ: ${enemy.defense} | ❤: ${enemy.health >= 0 ? enemy.health : 0}/${enemy.maxHealth}`;
            
            // Оновлюємо health bar ворога
            const enemyHealthPercent = ((enemy.health >= 0 ? enemy.health : 0) / enemy.maxHealth) * 100;
            elements.enemyHealthBar.style.width = `${enemyHealthPercent}%`;
        }

        // Ховаємо ворога
        function hideEnemy() {
            elements.enemyView.style.display = 'none';
        }

        // Перевірка на отримання нового рівня (оновлена версія для нового балансу)
        function checkLevelUp() {
            if (player.xp >= player.xpToNext) {
                player.level++;
                player.xp -= player.xpToNext;
                player.xpToNext = getXpByLevel(player.level);//Math.floor(player.xpToNext * 1.4);  // Зменшено множник досвіду
                player.baseAttack += 1;  // Зменшено приріст атаки за рівень
                player.baseDefense += 1; // Зменшено приріст захисту за рівень
                const oldMaxHealth = player.maxHealth;
                player.health += 5;  // Зменшено приріст здоров'я за рівень
                
                addLog(`✨ Вітаємо! Ви досягли ${player.level} рівня! Ваші характеристики зросли.`, 'system');
                showEventPopup(`✨ ${player.level} ✨`, document.getElementById('player-on-map'), {
                    color: '#ff0',
                    fontSize: '20px',
                    delay: 1000,
                    horizontalOffset: -20,
                    popupType: 'slow',
                });

                if (oldMaxHealth < player.maxHealth) {
                    addLog(`❤️ Ваше максимальне здоров'я збільшилось до ${player.maxHealth}`, 'system');
                }
                // заліковуємо рани
                player.health = player.maxHealth;

                // Додаємо фруктові клітинки при отриманні рівня
                spawnFruits();
                updateStats();
                
                // Оновлюємо карту з новими ворогами та артефактами
                //spawnEnemies();
                spawnArtifacts();
                return true;
            }
            return false;
        }

        // Лікування
        function heal() {
            if (player.gold >= 10) {
                player.gold -= 10;
                const deltaHealth = player.maxHealth - player.health;
                player.health = player.maxHealth;
                addLog('💊 Ви повністю вилікувались!', 'system');
                showEventPopup(`+${deltaHealth}❤️`, elements.playerEmoji, {
                    color: '#0f0',
                    fontSize: '22px'
                });
                
                // Оновлюємо health bar
                elements.playerHealthBar.style.width = '100%';
                updateStats();
            } else {
                addLog('❌ У вас недостатньо золота для лікування!', 'system');
            }
        }

        // Воскресіння
        function resurrect() {
            if (player.health > 0) return;

            // Ховаємо кнопку воскресіння
            elements.resurrectBtn.style.display = 'none';

            const lostGold = Math.round(player.gold * 0.5);

            addLog(`📈 Ви втратили ${player.xp} досвіду!`, 'system', 'red');
            addLog(`💰 Ви втратили ${lostGold} золота!`, 'system', 'red');

            /*showEventPopup(`-${player.xp}📈`, document.getElementById('player-on-map'), {
                fontSize: '22px',
                horizontalOffset: 20,
            });
            showEventPopup(`-${lostGold}💰`, document.getElementById('player-on-map'), {
                fontSize: '22px',
                delay: 200,
                horizontalOffset: -50,
            });*/
            showGameMessage(`Ви втратили 📈 ${player.xp} досвіду і 💰 ${lostGold} золота!`, 0);

            player.gold = player.gold - lostGold;
            player.xp = 0;
            player.health = player.maxHealth;
            addLog('⚡ Ви воскресли і повністю відновили здоров\'я!', 'system');
            
            // Оновлюємо health bar
            updateStats();
            
            // Вороги також відпочивають (респавняться)
            enemies = [];
            respawnObstacles();
            spawnEnemies();
            updateMap();
        }

        // Обробники подій
        elements.healBtn.addEventListener('click', heal);
        elements.resurrectBtn.addEventListener('click', resurrect);

        // Глобальні функції для виклику з HTML
        window.equipItem = equipItem;
        window.sellItem = sellItem;

        // Оновлене початкове повідомлення
        addLog('🌈 Ласкаво просимо в Емодзі RPG з потужними еліксирами!', 'system');
        addLog('🧪 Тепер у світі можна знайти 3 види еліксирів:', 'system');
        addLog('⚔️ Еліксир сили - постійно збільшує атаку', 'system');
        addLog('🛡️ Еліксир захисту - постійно збільшує захист', 'system');
        addLog('❤️ Еліксир життя - постійно збільшує здоров\'я', 'system');
        addLog('⚠️ Еліксири дуже рідкісні та не продаються!', 'system');
        addLog('🗺️ Клацайте на клітинки карти, щоб рухатись.', 'system');
        
        // Ініціалізація гри
        initMap();
        updateStats();
        updateInventory();
        
        // Додамо стартову зброю та броню
        //player.inventory.push({...weapons[8]}); // test
        /*
        player.inventory.push({...weapons[0]}); // Дерев'яний меч
        player.inventory.push({...armors[0]});  // Шкіряний жилет
        */
        updateInventory();
    </script>
    {/ignore}