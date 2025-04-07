    {ignore}
    <script>
        let icons = {};
        // отримуємо всі іконкі з атласу. дякую: https://www.codeandweb.com/free-sprite-sheet-packer
        fetch('/templates/img/minirpg/clay/clay.json')
            .then(response => response.json())
            .then(data => {
                // спочатку підгружаєм всі іконки
                icons = data;
                // лише потім стартуєм ВСЬО!
                beginAll();
            })
            .catch(error => {
            console.error('Помилка завантаження JSON:', error);
        });
    </script>
    {/ignore}
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

        .emoji-sprite {
            width: 64px;
            height: 64px;
            background-image: url('/templates/img/minirpg/clay/icons.png');
            background-size: auto; /* або вказати розміри атласу */
        }

        .modal-header {
            display: block;
            position: absolute;
            width: 100%;
            border: 2px solid #4CAF50;
            border-radius: 9px;
            top: -78px;
            background-color: #222;
            font-size: 20px;
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
            height: 23vh;
            overflow-y: scroll;
            border: 1px solid #444;
            padding: 10px;
            margin-top: 25px;
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
            margin: 15px 0 0 0;
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
            transition: width 0.5s;
        }
        .player-health .health-fill {
            background-color: #0a0;
        }
        .player-health .overpowered {
            background-color: #8c1ce5;
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
            transition: width 0.5s;
        }
        .player-xp .xp-fill {
            background-color: #fff400;
        }
        .megahealth {
            filter: drop-shadow(0px 0px 11px #ff00ff);
            animation: pulse 1.5s infinite;
            display: inline-block;
            width: 20px;
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
            overflow-y: scroll;
            height: 435px;
            position: relative;
        }
        #closeInventoryBtn {
            position: absolute;
            z-index: 20;
            right: 10px;
            top: 0px;
            padding: 3px 3px 0px 3px;
            color: #000;
            background-color: #555;
        }
        .item-desc {
            padding-left: 5px;
        }
        .item-slot {
            display: inline-block;
            margin: 5px;
            padding: 5px;
            background-color: #444;
            border-radius: 3px;
            cursor: pointer;
            position: relative;
            text-align: center;
            width: 31%;
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
            top: 80%;
            left: 0;
            background-color: #555;
            border-radius: 3px;
            z-index: 10;
            border: 1px #009fff solid;
            box-shadow: 3px 3px 3px #00ffa58a;
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

        .upgraded-stat {
            color: #ff8f00;
            text-shadow: 2px 2px 1px #000;
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
        #equipment .equipment-slot {
            min-height: 122px;
        }
        #map-container {
            /*margin: 15px 0;*/
            position: relative;
        }
        #map {
            display: grid;
            grid-template-columns: repeat(11, 1fr);
            gap: 1px;
            width: 64%;
            justify-self: center;
        }
        .map-cell.incognita-cell {
            background-color: #333;
        }
        .map-cell {
            width: 33px;
            height: 33px;
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
        /*.artifact-bonus {
            font-size: 16px;
            color: #ffffff;
            position: absolute;
            display: block;
            bottom: 2px;
            width: 100%;
            text-shadow: 2px 2px #000;
            padding-right: 10px;
        }*/
        
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
        .potion-health { color: #ffb300; }
        .potion-attack { color: #0f0; }
        .potion-defense { color: #00ceff; }
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
            animation: popup 2s forwards;
            pointer-events: none;
            z-index: 100;
        }
        
        .event-popup-slow {
            font-size: 24px;
            font-weight: bold;
            animation: popup 4s forwards;
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

        .chest-cell, .chest-cell:hover{
            animation: fruit-pulse 2s infinite;
            border-radius: 50%;
            color: #fdac0096;
            background-color: #fdac0096;
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
            background: radial-gradient(circle at center, white 0, #777, #555 78%);
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

        .emoji-replaced {
            /*image-rendering: pixelated;*/
        }
        .popup-info .emoji-replaced {
            padding-bottom: 6px;
        }
    </style>
    <div id="game">
        <!--<h1>🏰 Емодзі RPG з артефактами 🏰</h1>-->
        
        <div id="game-modal" class="modal">
            <div class="modal-content">
                <div style="width: 100%; position: relative;display: block;">
                    <div class="modal-header" id="modal-header">Локацію зачищено</div>
                </div>
                <p id="modal-message"></p>
                <button id="modal-ok" class="modal-button">OK</button>
            </div>
        </div>

        <div class="flex-container">
            <div class="game-column">
                <div id="battle-view">
                    <div id="player-view">
                        <div id="player-emoji">
                            <span class="emoji-replace" data-emoji="🧙‍♂️" data-size="64px">🧙‍♂️</span>
                        </div>
                        <div class="stats">
                            <span class="emoji-replace" data-emoji="⚔️" data-size="20px">АТК</span>: <span id="attack-display" >10</span> | 
                            <span class="emoji-replace" data-emoji="🛡️" data-size="20px">ЗАХ</span>: <span id="defense-display">5</span> | 
                            <span id="playerHeartEmoji" class="emoji-replace" data-emoji="❤️" data-size="20px">❤️</span>: <span id="max-health-display">100</span> <!--💜-->
                        </div>
                        <div class="health-bar player-health">
                            <div class="health-fill" id="player-health-bar"></div>
                        </div>
                        <div class="xp-bar player-xp">
                            <div class="xp-fill" id="player-xp-bar"></div>
                        </div>
                        <div id="stats" class="stats">
                            <span class="emoji-replace" data-emoji="👑" data-size="20px">👑</span>: <span id="level">1</span> |
                            <span class="emoji-replace" data-emoji="💰" data-size="20px">💰</span>: <span id="gold">0</span> |
                            <span class="emoji-replace" data-emoji="📈" data-size="20px">📈</span>: <span id="xp">0</span>/<span id="xpToNext">50</span>
                        </div>
                    </div>
                    <div id="vs"><span class="emoji-replace" data-emoji="⚔️" data-size="64px">⚔️</span></div>
                    <div id="enemy-view" style="display: block;">
                        <div id="enemy-emoji">👤</div>
                        <div class="stats" id="enemy-stats">
                            <span class="emoji-replace" data-emoji="⚔️" data-size="20px">АТК</span>: ? |
                            <span class="emoji-replace" data-emoji="🛡️" data-size="20px">ЗАХ</span>: ? |
                            <span class="emoji-replace" data-emoji="❤️" data-size="20px">❤️</span>: 0
                        </div>
                        <div class="health-bar">
                            <div class="health-fill" id="enemy-health-bar"></div>
                        </div>
                    </div>
                </div>
                
                <div id="controls">
                    <button id="inventoryBtn" style="display: inline-block; min-width: 216px;">🎒 Інвентар <span id='inventoryFullness'>(Пусто)</span> [I]</button>
                    <button id="mapBtn" style="display: none; min-width: 216px;">🗺️ Карта [I]</button>
                    <button id="healBtn" style="display: none;">💊 Лікуватися (10 золота)</button>
                    <button id="gambleBtn" style="display: inline-block;">🎰 Гемблінг (<span id="gamblePrice">50💰</span>) [G]</button>
                    <button id="resurrectBtn" style="display: none;">💀 Відродитись [R]</button>
                </div>

                <div id="equipment">
                    <div>⚔️ Зброя: <span id="weapon-slot" class="equipment-slot">Пусто</span></div>
                    <div>🛡️ Броня: <span id="armor-slot" class="equipment-slot">Пусто</span></div>
                    <div>💍 Кільце: <span id="ring-slot" class="equipment-slot">Пусто</span></div>
                    <div>📿 Амулет: <span id="amulet-slot" class="equipment-slot">Пусто</span></div>
                    <div>📖 Книга: <span id="book-slot" class="equipment-slot">Пусто</span></div>
                    <div>🏆 Реліквія: <span id="relic-slot" class="equipment-slot">Пусто</span></div>
                </div>
            </div>

            <div class="game-column">
                <div id="map-container">
                    <div id="map"></div>
                    <div id="inventory" style="display:none;">
                        <div>🎒 Інвентар</div>
                        <button id="closeInventoryBtn">❌</button>
                        <div id="inventory-items"></div>
                    </div>
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
            overpoweredHealth: 0, // Тимчасовий Бонус від стейку дає надпотужне здоров'я, яке працює як мега-хелс 
            bonusHealth: 0, // Бонусне здоров'я яке додається еліксирами
            baseAttack: 3,  // Зменшено базову атаку
            baseDefense: 3, // Зменшено базовий захист
            gold: 0,
            xp: 0,
            xpToNext: 50,  // Необхідний досвід до наступного рівня
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
            isBattle: false,
            inInventory: false,
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
                if (this.equipment.armor) maxHealth += (this.equipment.armor.maxHealth || 0);
                if (this.equipment.ring) maxHealth += (this.equipment.ring.maxHealth || 0);
                if (this.equipment.amulet) maxHealth += (this.equipment.amulet.maxHealth || 0);
                if (this.equipment.book) maxHealth += (this.equipment.book.maxHealth || 0);
                if (this.equipment.relic) maxHealth += (this.equipment.relic.maxHealth || 0);
                // додаєм потужне мега-життя
                maxHealth += player.overpoweredHealth;

                return maxHealth;
            }
        };

        const emptySlotsEquipmentsEmojies = {
            'weapon': '🗡',
            'armor': '🛡️✨',
            'ring': '💍✨',
            'amulet': '📿🔥',
            'book': '📖',
            'relic': '🔮',
        };
        const equipableTypes = ['weapon', 'armor', 'ring', 'amulet', 'book', 'relic'];

        const extraStyleMainIcons = 'vertical-align: sub !important; margin-left: 4px; margin-bottom: 2px';

        // бібліотека емоджі
        const emojiReplacer = [
                // базові
            { type: '❤️', image: 'health.png' },
            { type: '💖', image: 'sparkling-heart.png' },
            { type: '💜', image: 'purple-heart.png' },
            { type: '💰', image: 'money-sack.png' },
            { type: '⚔️', image: 'attack.png' },
            { type: '🛡️', image: 'defense.png' },
            { type: '👑', image: 'crown.png' },
            { type: '📈', image: 'xp.png' },
            { type: '🧙‍♂️', image: 'wizard.png' },
            { type: '📦', image: 'chest.png' },
            { type: '📦👑', image: 'chest-golden.png' },
            { type: '💼', image: 'prize.png' },
            { type: '💀', image: 'skull.png' },
            { type: '🔥', image: 'fire.png' },
            { type: '💥', image: 'crit.png' },
            { type: '☣️', image: 'poison.png' },
            { type: '💨', image: 'windblow.png' },
            { type: '💚', image: 'regeneration.png' },
            { type: '🩸', image: 'blood.png' },
            { type: '🤢', image: 'sick.png' },
            { type: '💪', image: 'muscle.png' },
                // перешкоди
            { type: '🗻', image: 'obs-mountain-2.png' },
            { type: '🌳', image: 'obs-tree-3.png' },
            { type: '🌲', image: 'obs-tree-4.png' },
                // фрукти
            { type: '🍎', image: 'red-apple.png' },
            { type: '🍌', image: 'banana.png' },
            { type: '🍇', image: 'grapes.png' },
            { type: '🍕', image: 'pizza.png' },
            { type: '🥩', image: 'meat.png' },
                // weapon
            { type: '🗡', subtype: 1, image: 'wooden-sword.png' },
            { type: '🔪', subtype: 1, image: 'weapon-dagger.png' },
            { type: '🏏', subtype: 3, image: 'weapon-club.png' },
            { type: '🪓', subtype: 4, image: 'weapon-axe.png' },
            { type: '🔱', subtype: 5, image: 'weapon-spear.png' },
            { type: '🗡️', subtype: 6, image: 'weapon-sword.old.png' },
            { type: '🗡️', subtype: 14, image: 'weapon-sword.png' },
            { type: '🏏', subtype: 7, image: 'weapon-flail.png' },
            { type: '🔨', subtype: 8, image: 'weapon-hammer.png' },
            { type: '🏹', subtype: 9, image: 'weapon-bow.png' },
            { type: '🎯', subtype: 10, image: 'weapon-crossbow.png' },
            { type: '🗡', subtype: 11, image: 'weapon-katana.png' },
            { type: '🗡🔥', subtype: 12, image: 'weapon-firesword.png' },
            { type: '🗡✨', subtype: 13, image: 'weapon-myth-sword.png' },
                // броня
            { type: '🥼', subtype: 1, image: 'armor-cloak.png' },
            { type: '🧥', subtype: 2, image: 'leather-armor.png' },
            { type: '🧥✨', subtype: 2, image: 'leather-armor-2.png' },
            { type: '⛓️', subtype: 3, image: 'armor-chainmail.png' },
            { type: '⛓️✨', subtype: 3, image: 'armor-chainmail-2.png' },
            { type: '⛓️', subtype: 4, image: 'scale-armour.png' },
            { type: '🛡️🛡️', subtype: 5, image: 'armor-cuirass.png' },
            { type: '🛡️✨', subtype: 5, image: 'armor-cuirass-2.png' },
            { type: '🛡️🛡️', subtype: 6, image: 'plate-armor.png' },
            { type: '🛡️👑', subtype: 7, image: 'armor-of-myth.png' },
            { type: '🛡️✨', subtype: 7, image: 'armor-of-myth-2.png' },
            { type: '🐉⛓️', subtype: 8, image: 'dragon-armor.png' },
            { type: '🛡️🌟', subtype: 9, image: 'legendary-armor.png' },
            { type: '🛡️✨', subtype: 10, image: 'elven-armor.png' },
                // кільця
            { type: '💍', subtype: 1, image: 'copper-ring.png' },
            { type: '💍', subtype: 2, image: 'silver-ring.png' },
            { type: '💍', subtype: 10, image: 'golden-ring.png' },
            { type: '💍', subtype: 3, image: 'ring-of-strength.png' },
            { type: '💍', subtype: 4, image: 'ring-of-defense.png' },
            { type: '💍', subtype: 5, image: 'ring-of-warrior.png' },
            { type: '💍', subtype: 6, image: 'ring-of-wizard.png' },
            { type: '💍🌟', subtype: 7, image: 'ring-of-titan.png' },
            { type: '💍🐉', subtype: 8, image: 'ring-of-dragon.png' },
            { type: '💍✨', subtype: 9, image: 'ring-of-immortality.png' },
                // Амулети
            { type: '📿', subtype: 1, image: 'wooden-amulet.png' },
            { type: '📿', subtype: 2, image: 'amulet-of-health.png' },
            { type: '📿', subtype: 3, image: 'amulet-of-warrior.png' },
            { type: '📿', subtype: 4, image: 'amulet-of-wisdom.png' },
            { type: '📿', subtype: 5, image: 'amulet-of-berserk.png' },
            { type: '📿', subtype: 6, image: 'amulet-of-protection.png' },
            { type: '📿', subtype: 7, image: 'amulet-of-balanse.png' },
            { type: '📿🌟', subtype: 8, image: 'amulet-of-immortality.png' },
            { type: '📿🔥', subtype: 9, image: 'amulet-of-phoenix.png' },
                // книги
            { type: '📖', subtype: 1, image: 'book.png' },
            { type: '📖', subtype: 2, image: 'book-2.png' },
            { type: '📖', subtype: 3, image: 'book-3.png' },
            { type: '📖', subtype: 4, image: 'book-4.png' },
            { type: '📖', subtype: 5, image: 'book-5.png' },
                // релікти
            { type: '🏆', subtype: 1, image: 'relic-01.png' },
            { type: '🏆', subtype: 2, image: 'relic-02.png' },
            { type: '🏆', subtype: 3, image: 'relic-03.png' },
            { type: '🏆', subtype: 4, image: 'relic-04.png' },
            { type: '🏆🐉', subtype: 5, image: 'relic-05.png' },
            { type: '🏆🌟', subtype: 6, image: 'relic-06.png' },
            { type: '👑🔥', subtype: 7, image: 'relic-07.png' },
            { type: '🔮', subtype: 8, image: 'relic-08.png' },

            // монстри
                // звичайні
            { type: '👺', image: 'goblin.png' },
            { type: '💀💀', image: 'skeleton.png' },
            { type: '🐕', image: 'wolf.png' },
            { type: '🕷️', image: 'spider.png' },
            { type: '🐀', image: 'rat.png' },
            { type: '🧟', image: 'zombie.png' },
            { type: '👻', image: 'ghost.png' },
            { type: '🦅', image: 'harpy.png' },
            { type: '🦎', image: 'cobold.png' },
                // елітні
            { type: '👹', image: 'orc.png' },
            { type: '🤢🤢', image: 'troll.png' },
            { type: '🐺', image: 'varg.png' },
            { type: '🧛', image: 'vampire.png' },
            { type: '😈', image: 'demon.png' },
                // боси
            { type: '🐉', image: 'dragon.png' },
            { type: '🎃', image: 'pumpkinhead.png' },
            { type: '🤬', image: 'archidemon.png' },
            { type: '🕸️', image: 'spider-queen.png' },

            // зілля
            { type: '🧪', subtype: 1, image: 'potion-1.png' },
            { type: '🧪', subtype: 2, image: 'potion-2.png' },
            { type: '🧪', subtype: 3, image: 'potion-3.png' },
        ];

        // перешкоди
        const obstacles = [
            { type: 'tree', emoji: '🌳', color: '#2a5a1a', name: 'Дерево' },
            { type: 'tree', emoji: '🌲', color: '#2a5a1a', name: 'Сосна' },
            { type: 'mountain', emoji: '🗻', color: '#aaaaaa', name: 'Гора' }
        ];

        // Оновлена база даних зброї з параметрами критичної шкоди
        const weapons = [
            { name: "Дерев'яний меч", emoji: "🗡",  subtype: 1, attack: 1, critChance: 0.03, rarity: 1, value: 5, type: "weapon" },
            { name: "Кинджал", emoji: "🔪",         subtype: 2, attack: 2, critChance: 0.15, rarity: 1, value: 10, type: "weapon" },
            { name: "Дубець", emoji: "🏏",          subtype: 3, attack: 3, critChance: 0.08, rarity: 2, value: 25, type: "weapon" },
            { name: "Сокира", emoji: "🪓",          subtype: 4, attack: 4, critChance: 0.1, rarity: 2, value: 50, type: "weapon" },
            { name: "Спис", emoji: "🔱",            subtype: 5, attack: 5, critChance: 0.1, rarity: 3, value: 80, type: "weapon" },
            { name: "Меч", emoji: "🗡️",             subtype: 6, attack: 6, critChance: 0.12, rarity: 3, value: 125, type: "weapon" },
            { name: "Обушок", emoji: "🏏",          subtype: 7, attack: 7, critChance: 0.1, rarity: 4, value: 200, type: "weapon" },
            { name: "Бойовий молот", emoji: "🔨",   subtype: 8, attack: 8, critChance: 0.07, rarity: 4, value: 350, type: "weapon" },
            { name: "Лук", emoji: "🏹",             subtype: 9, attack: 6, critChance: 0.2, rarity: 3, value: 200, type: "weapon" },
            { name: "Арбалет", emoji: "🎯",         subtype: 10, attack: 8, critChance: 0.25, rarity: 4, value: 350, type: "weapon" },
            { name: "Магічний меч", emoji: "🗡️",    subtype: 14, attack: 7, critChance: 0.3, rarity: 5, value: 350, type: "weapon" },
            { name: "Катана", emoji: "🗡",          subtype: 11, attack: 9, critChance: 0.15, rarity: 5, value: 600, type: "weapon" },
            { name: "Вогняний меч", emoji: "🗡🔥",  subtype: 12, attack: 12, critChance: 0.15, rarity: 5, value: 1200, type: "weapon" },
            { name: "Міфічний клинок", emoji: "🗡✨", subtype: 13, attack: 15, critChance: 0.2, rarity: 6, value: 2000, type: "weapon" }
        ];

        // Розширена база даних броні
        const armors = [
            { name: "Плащ", emoji: "🥼",            subtype: 1, defense: 1, rarity: 1, value: 5, type: "armor" },
            { name: "Шкіряна броня", emoji: "🧥",   subtype: 2, defense: 2, rarity: 1, value: 10, type: "armor" },
            { name: "Шкапова броня", emoji: "🧥✨", subtype: 1, defense: 2, maxHealth: 5, rarity: 1, value: 25, type: "armor" },
            { name: "Кольчуга", emoji: "⛓️",        subtype: 3, defense: 3, rarity: 2, value: 25, type: "armor" },
            { name: "Бехтер", emoji: "⛓️✨",        subtype: 3, defense: 3, maxHealth: 5, rarity: 2, value: 50, type: "armor" },
            { name: "Луската броня", emoji: "⛓️",   subtype: 4, defense: 4, rarity: 2, value: 50, type: "armor" },
            { name: "Кіраса", emoji: "🛡️🛡️",        subtype: 5, defense: 5, rarity: 3, value: 100, type: "armor" },
            { name: "Панцир", emoji: "🛡️✨",        subtype: 5, defense: 5, maxHealth: 10, rarity: 3, value: 200, type: "armor" },
            { name: "Латна броня", emoji: "🛡️🛡️",   subtype: 6, defense: 6, rarity: 3, value: 200, type: "armor" },
            { name: "Міфічна броня", emoji: "🛡️👑", subtype: 7, defense: 7, rarity: 4, value: 350, type: "armor" },
            { name: "Елітна броня", emoji: "🛡️✨",  subtype: 7, defense: 7, maxHealth: 10, rarity: 4, value: 600, type: "armor" },
            { name: "Драконяча шкура", emoji: "🐉⛓️", subtype: 8, defense: 8, rarity: 4, value: 700, type: "armor" },
            { name: "Легендарна броня", emoji: "🛡️🌟", subtype: 9, defense: 10, rarity: 5, value: 1000, type: "armor" },
            { name: "Ельфійська броня", emoji: "🛡️✨", subtype: 10, defense: 13, rarity: 6, value: 2000, type: "armor" }
        ];

        // Розширена база даних артефактів
        const artifacts = [
            // Кільця
            { name: "Мідне кільце", emoji: "💍",    subtype: 1, attack: 1, rarity: 1, value: 5, type: "ring" },
            { name: "Срібне кільце", emoji: "💍",   subtype: 2, defense: 1, rarity: 1, value: 5, type: "ring" },
            { name: "Золоте кільце", emoji: "💍",   subtype: 10, maxHealth: 5, rarity: 1, value: 5, type: "ring" },
            { name: "Кільце сили", emoji: "💍",     subtype: 3, attack: 2, rarity: 2, value: 20, type: "ring" },
            { name: "Кільце захисту", emoji: "💍",  subtype: 4, defense: 2, rarity: 2, value: 40, type: "ring" },
            { name: "Кільце воїна", emoji: "💍",    subtype: 5, attack: 3, defense: 1, rarity: 3, value: 100, type: "ring" },
            { name: "Кільце мага", emoji: "💍",     subtype: 6, attack: 1, defense: 3, rarity: 3, value: 100, type: "ring" },
            { name: "Кільце титана", emoji: "💍🌟", subtype: 7, attack: 4, defense: 4, rarity: 5, value: 300, type: "ring" },
            { name: "Кільце дракона", emoji: "💍🐉", subtype: 8, attack: 5, defense: 3, rarity: 5, value: 300, type: "ring" },
            { name: "Кільце безсмертя", emoji: "💍✨", subtype: 9, attack: 3, defense: 5, maxHealth: 10, rarity: 6, value: 800, type: "ring" },
            
            // Амулети
            { name: "Дерев'яний амулет", emoji: "📿",   subtype: 1, maxHealth: 5, rarity: 2, value: 10, type: "amulet" },
            { name: "Амулет здоров'я", emoji: "📿",     subtype: 2, maxHealth: 10, rarity: 2, value: 30, type: "amulet" },
            { name: "Амулет воїна", emoji: "📿",        subtype: 3, attack: 2, maxHealth: 5, rarity: 3, value: 50, type: "amulet" },
            { name: "Амулет мудрості", emoji: "📿",     subtype: 4, defense: 2, maxHealth: 5, rarity: 3, value: 50, type: "amulet" },
            { name: "Амулет берсерка", emoji: "📿",     subtype: 5, attack: 4, defense: -1, rarity: 4, value: 100, type: "amulet" },
            { name: "Амулет захисника", emoji: "📿",    subtype: 6, defense: 4, attack: -1, rarity: 4, value: 100, type: "amulet" },
            { name: "Амулет балансу", emoji: "📿",      subtype: 7, attack: 2, defense: 2, maxHealth: 10, rarity: 5, value: 250, type: "amulet" },
            { name: "Амулет безсмертя", emoji: "📿🌟",  subtype: 8, maxHealth: 40, rarity: 5, value: 500, type: "amulet" },
            { name: "Амулет фенікса", emoji: "📿🔥",    subtype: 9, maxHealth: 30, attack: 3, rarity: 6, value: 1000, type: "amulet" },
            
            // Книги
            { name: "Книга бійця", emoji: "📖",         subtype: 3, attack: 1, rarity: 2, value: 5, type: "book" },
            { name: "Книга початківця", emoji: "📖",    subtype: 3, defense: 1, rarity: 2, value: 5, type: "book" },
            { name: "Книга виживання", emoji: "📖",     subtype: 2, maxHealth: 5, rarity: 2, value: 5, type: "book" },
            { name: "Книга учня", emoji: "📖",          subtype: 4, attack: 1, defense: 1, rarity: 3, value: 10, type: "book" },
            { name: "Книга мечників", emoji: "📖",      subtype: 3, attack: 3, rarity: 3, value: 100, type: "book" },
            { name: "Книга захисників", emoji: "📖",    subtype: 4, defense: 3, rarity: 3, value: 100, type: "book" },
            { name: "Книга знань", emoji: "📖",         subtype: 5, attack: 2, defense: 2, rarity: 4, value: 150, type: "book" },
            { name: "Книга воєнних мистецтв", emoji: "📖", subtype: 1,  attack: 5, defense: 1, rarity: 4, value: 500, type: "book" },
            { name: "Книга древніх", emoji: "📖",       subtype: 3, defense: 5, attack: 1, rarity: 5, value: 500, type: "book" },
            { name: "Заборонений фоліант", emoji: "📖", subtype: 2, attack: 5, defense: 5, maxHealth: 15, rarity: 5, value: 1000, type: "book" },
            { name: "Книга пророцтв", emoji: "📖",      subtype: 1, attack: 7, defense: 7, maxHealth: 20, rarity: 6, value: 2000, type: "book" },
            
            // Реліквії
            { name: "Святий тютюн", emoji: "🏆",    subtype: 1, maxHealth: 10, rarity: 3, value: 30, type: "relic" },
            { name: "Камінці безодні", emoji: "🏆", subtype: 2, maxHealth: 20, rarity: 4, value: 100, type: "relic" },
            { name: "Кристал влади", emoji: "🏆",   subtype: 3, attack: 5, rarity: 4, value: 250, type: "relic" },
            { name: "Чиста руна", emoji: "🏆",      subtype: 4, defense: 5, rarity: 4, value: 350, type: "relic" },
            { name: "Око дракона", emoji: "🏆🐉",   subtype: 5, attack: 7, defense: 3, rarity: 5, value: 1000, type: "relic" },
            { name: "Серце дракона", emoji: "🏆🌟", subtype: 6, attack: 8, defense: 8, maxHealth: 30, rarity: 5, value: 1500, type: "relic" },
            { name: "Корона вогню", emoji: "👑🔥",  subtype: 7, attack: 5, defense: 5, maxHealth: 25, rarity: 6, value: 2200, type: "relic" },
            { name: "Палантір", emoji: "🔮",        subtype: 8, attack: 10, defense: 10, maxHealth: 40, rarity: 6, value: 3500, type: "relic" }
        ];
        
        // Додаємо еліксири до бази даних предметів
        const potions = [
            { name: "Еліксир сили", emoji: "🧪", subtype: 1, type: "potion_attack", emojiType: "⚔️", description: "⚔️+1", effect: "attack", value: 1, rarity: 2, canSell: false, color: '#0f0' },
            { name: "Еліксир захисту", emoji: "🧪", subtype: 2, type: "potion_defense", emojiType: "🛡️", description: "🛡️+1", effect: "defense", value: 1, rarity: 2, canSell: false, color: '#00ceff' },
            { name: "Еліксир життя", emoji: "🧪", subtype: 3, type: "potion_health", emojiType: "💖", description: "💖+5", effect: "maxHealth", value: 5, rarity: 2, canSell: false, color: 'red' }
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
            /*{ 
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
            },*/
            { 
                name: "Піцца", 
                emoji: "🍕",
                healPercent: 0.5,   // 50% здоров'я
                rarity: 2, 
                type: "fruit",
                color: "#ffeb3b"  // Жовтий
            },
            { 
                name: "Стейк",
                emoji: "🥩",
                healPercent: 1.0,   // 100% здоров'я
                rarity: 3, 
                type: "fruit",
                color: "#673ab7"  // Фіолетовий
            }
        ];

        const enemyTypes = [
            // Звичайні монстри
            { type: 'Гоблін', emoji: '👺', color: '#5f5', abilities: [] },
            { type: 'Скелет', emoji: '💀💀', color: '#fff', abilities: ['undead', 'disease'] },
            { type: 'Вовк', emoji: '🐕', color: '#aaa', abilities: ['fast', 'predator'] },
            { type: 'Павук', emoji: '🕷️', color: '#8b4513', abilities: ['poison'] },
            { type: 'Щур', emoji: '🐀', color: '#808080', abilities: ['disease'] },
            { type: 'Зомбі', emoji: '🧟', color: '#5a5', abilities: ['undead', 'tough', 'disease'] },
            { type: 'Привид', emoji: '👻', color: '#aaf', abilities: ['undead', 'magic_resist'] },
            { type: 'Гарпія', emoji: '🦅', color: '#add8e6', abilities: ['flying', 'fast'] },
            { type: 'Кобольд', emoji: '🦎', color: '#ff6347', abilities: ['trap_master'] },
            
            // Елітні монстри
            { type: 'Орк-воїн', emoji: '👹', color: '#f55', abilities: ['strong', 'tough'], elite: true },
            { type: 'Троль', emoji: '🤢🤢', color: '#228b22', abilities: ['regeneration', 'tough'], elite: true },
            { type: 'Варґ', emoji: '🐺', color: '#4b0082', abilities: ['predator', 'fast'], elite: true },
            { type: 'Вампір', emoji: '🧛', color: '#00ffff', abilities: ['undead', 'bloodsucker', 'magic_resist'], elite: true },
            { type: 'Демон', emoji: '😈', color: '#ff0000', abilities: ['fire_aura', 'magic_resist'], elite: true },
            
            // Боси
            { type: 'Дракон', emoji: '🐉', color: '#f33', abilities: ['fire_breath', 'flying', 'tough'], boss: true },
            { type: 'Гарбузоголовий', emoji: '🎃', color: '#800080', abilities: ['strong', 'tough', 'stomp'], boss: true },
            { type: 'Архідемон', emoji: '🤬', color: '#8b0000', abilities: ['fire_aura', 'bloodsucker', 'fear'], boss: true },
            { type: 'Королева павуків', emoji: '🕸️', color: '#000000', abilities: ['poison', 'web', 'summon'], boss: true }
        ];

        // Карта гри
        const mapSize = 11;
        let gameMap = [];
        let enemies = [];
        let visitedCells = new Set();
        let terraCognita = new Set();

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
            gambleBtn: document.getElementById('gambleBtn'),
            gamblePrice: document.getElementById('gamblePrice'),
            resurrectBtn: document.getElementById('resurrectBtn'),
            inventoryBtn: document.getElementById('inventoryBtn'),
            closeInventoryBtn: document.getElementById('closeInventoryBtn'),
            mapBtn: document.getElementById('mapBtn'),
            playerHealthBar: document.getElementById('player-health-bar'),
            playerXpBar: document.getElementById('player-xp-bar'),
            playerView: document.getElementById('player-view'),
            playerEmoji: document.getElementById('player-emoji'),
            playerHeartEmoji: document.getElementById('playerHeartEmoji'),
            enemyHealthBar: document.getElementById('enemy-health-bar'),
            enemyView: document.getElementById('enemy-view'),
            enemyEmoji: document.getElementById('enemy-emoji'),
            enemyStats: document.getElementById('enemy-stats'),
            vs: document.getElementById('vs'),
            inventory: document.getElementById('inventory'),
            inventoryItems: document.getElementById('inventory-items'),
            inventoryFullness: document.getElementById('inventoryFullness'),
            weaponSlot: document.getElementById('weapon-slot'),
            armorSlot: document.getElementById('armor-slot'),
            ringSlot: document.getElementById('ring-slot'),
            amuletSlot: document.getElementById('amulet-slot'),
            bookSlot: document.getElementById('book-slot'),
            relicSlot: document.getElementById('relic-slot'),
            map: document.getElementById('map')
        };

        // класичний рандом
        function rand(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
        }

        function chooseOne(list) {
            if (!Array.isArray(list) || list.length === 0) {
                throw new Error("Input must be a non-empty array");
            }
            const index = Math.floor(Math.random() * list.length);
            return list[index];
        }

        function getEnemyDefense(enemy) {
            let enemyDefense = enemy.defense;
            if (enemy.item != null && enemy.item.defense) enemyDefense += enemy.item.defense;
            return enemyDefense;
        }

        function getEnemyAttack(enemy) {
            let enemyAttack = enemy.attack;
            if (enemy.item != null && enemy.item.attack) enemyAttack += enemy.item.attack;
            return enemyAttack;
        }

        function getEnemyMaxHealth(enemy) {
            let enemyMaxHealth = enemy.maxHealth;
            if (enemy.item != null && enemy.item.maxHealth) enemyMaxHealth += enemy.item.maxHealth;
            return enemyMaxHealth;
        }

        function addTerraLight(playerX, playerY) {
            for (j = playerY - 1; j <= playerY + 1; j++) {
                for (i = playerX - 1; i <= playerX + 1; i++) {
                    if (gameMap[j] != null && gameMap[j][i] != null) {
                        terraCognita.add(`${i},${j}`);
                    }
                }
            }
        }

        // ховаєм всі доступні ячейки
        function resetTerra() {
            terraCognita = new Set();
            visitedCells = new Set();
        }

        function emojiReplace() {
            document.querySelectorAll('.emoji-replace').forEach(el => {
                const emoji = el.getAttribute('data-emoji');
                const size = el.getAttribute('data-size') ? el.getAttribute('data-size') : '16px';
                const style = el.style ? el.style : '';
                el.innerHTML = addEmoji(emoji, size, undefined, style);
            });
        }

        // замінник для емоджі
        function addEmoji(emoji = '❤️', size = '20px', subtype = 0, extraStyle = '') {
            // шукаєм картинку у емоджі реплейсері
            let imgData = emojiReplacer.find(er => er.type == emoji);
            // якщо картінка є продовжуєм
            if (typeof imgData != 'undefined') {
                // якщо для однієї емоджі можуть буть кілька варіантів
                if (subtype != 0) {
                    // шукаєм саме цей варіант
                    let imgData2 = emojiReplacer.filter(er => er.type == emoji).find(er2 => er2.subtype == subtype);
                    // використовуєм його або лишаем той шо вже є
                    if (typeof imgData2 != 'undefined') {
                        imgData = {...imgData2};
                    }
                }
                const baseSize = 64;
                const scaling = parseInt(size) / baseSize;

                const posX = icons.frames[imgData.image].frame.x * scaling;
                const posY = icons.frames[imgData.image].frame.y * scaling;
                const atlasX = icons.meta.size.w * scaling;
                const atlasY = icons.meta.size.h * scaling;

                const emojiStyle = `${extraStyle != '' ? extraStyle+'; ' : ''}display: inline-block; vertical-align: bottom; width:${size}; height:${size}; background-position: -${posX}px -${posY}px; background-size: ${atlasX}px ${atlasY}px;`;
                // замінюєм емоджі
                return `<span class="emoji-sprite emoji-replaced" style="${emojiStyle}"></span>`;
            }
            // лишаєм емоджі якщо нічо немає
            return emoji;
        }

        // типова для гравця іконка
        function addEmojiPlayer(emoji = '❤️', size = '20px') {
            return addEmoji(emoji, size, undefined, extraStyleMainIcons);
        }

        // один з ворогів рухається
        function moveRandomEnemy() {
            const _koords = [-1, 0, 1];

            if (enemies.length && Math.random() < 0.4) {
                const randomIndex = Math.floor(Math.random() * enemies.length);
                if (enemies[randomIndex].boss) {
                    return;
                }

                const randomX = enemies[randomIndex].position.x + _koords[Math.floor(Math.random() * _koords.length)];
                const randomY = enemies[randomIndex].position.y + _koords[Math.floor(Math.random() * _koords.length)];

                if (gameMap[randomY] != null && gameMap[randomY][randomX] != null) {
                    const targetCell = gameMap[randomY][randomX];

                    //console.log([enemies[randomIndex].position.x, enemies[randomIndex].position.y, enemies[randomIndex].type, ' => ', randomX, randomY, targetCell.type]);
                    if (targetCell.type == 'empty') {
                        const enemy = enemies.find(e => (e.position.x === randomX && e.position.y === randomY));
                        if (!enemy && player.position.x != randomX && player.position.y != randomY) {
                            enemies[randomIndex].position.x = randomX;
                            enemies[randomIndex].position.y = randomY;
                        }
                    }
                }
            }
        }

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
                            emoji: obstacleType === 'tree' ? chooseOne(['🌳', '🌲']) : '🗻',
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
            spawnChest();
            updateMap();
        }

        // Оновлена функція для відображення ворогів на карті
        function updateMap() {
            const cells = document.querySelectorAll('.map-cell');
            
            visitedCells.add(`${player.position.x},${player.position.y}`);
            addTerraLight(player.position.x, player.position.y);
            
            cells.forEach(cell => {
                const x = parseInt(cell.dataset.x);
                const y = parseInt(cell.dataset.y);
                
                cell.className = 'map-cell incognita-cell';
                cell.textContent = terraCognita.has(`${x},${y}`) ? gameMap[y][x].emoji : emptyEmoji;
                cell.id = '';
                
                if (visitedCells.has(`${x},${y}`)) {
                    cell.classList.add('visited-cell');
                }
                if (terraCognita.has(`${x},${y}`)) {
                    cell.classList.remove('incognita-cell');
                }
                
                if (x === player.position.x && y === player.position.y) {
                    cell.innerHTML = addEmoji(player.emoji, '30px');
                    cell.classList.add('player-cell');
                    cell.id = 'player-on-map';
                    return;
                }
                
                if (terraCognita.has(`${x},${y}`)) {
                    if (gameMap[y][x].type === 'obstacle') {
                        cell.classList.add('obstacle-cell');
                        cell.classList.add('tree-cell');
                        cell.innerHTML = addEmoji(gameMap[y][x].emoji, '30px');
                    }

                    const enemy = enemies.find(e => e.position.x === x && e.position.y === y);
                    if (enemy) {
                        cell.innerHTML = addEmoji(enemy.emoji, '30px');
                        
                        if (enemy.boss) cell.classList.add('boss-cell');
                        else if (enemy.elite) cell.classList.add('elite-cell');
                        else if (enemy.abilities.includes('magic')) cell.classList.add('magic-cell');
                        else cell.classList.add('enemy-cell');
                        return;
                    }
                    
                    if (gameMap[y][x].type === 'artifact') {
                        if (gameMap[y][x].artifact.type.startsWith('potion')) {
                            cell.innerHTML = addEmoji(gameMap[y][x].emoji, '30px', gameMap[y][x].artifact.subtype);
                            cell.classList.add('potion-cell');
                        } else {
                            cell.innerHTML = addEmoji('💼', '30px', gameMap[y][x].artifact.subtype);
                            cell.classList.add('artifact-cell');
                        }
                        return;
                    }

                    if (gameMap[y][x].type === 'fruit') {
                        cell.innerHTML = addEmoji(gameMap[y][x].emoji, '30px');
                        cell.classList.add('fruit-cell');
                        cell.style.color = gameMap[y][x].color;
                        cell.dataset.fruit = Math.floor(gameMap[y][x].fruit.healPercent * 100);
                        return;
                    }

                    if (['treasure', 'chest'].includes(gameMap[y][x].type)) {
                        cell.innerHTML = addEmoji(gameMap[y][x].emoji, '30px');
                        
                        if (gameMap[y][x].type === 'chest') {
                            cell.classList.add('chest-cell');
                        }
                    }
                }
            });
        }

        // Переміщення гравця
        function movePlayer(x, y) {
            if (player.health <= 0) {
                addLog('💀 Ви мертві і не можете рухатись!', 'system');
                return;
            }
            if (player.isBattle === true) {
                addLog('🚫 Під час битви не можна рухатись!', 'system');
                return;
            }

            if (player.overpoweredHealth > 0) {
                player.overpoweredHealth--;
                if (player.health > player.maxHealth) player.health--;
                updateStats();
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

            // Битва починається
            if (enemyIndex !== -1) {
                // під час битви не рухаєм
                player.isBattle = true;

                const targetOnMap = document.querySelector(`.map-cell[data-x="${x}"][data-y="${y}"]`);

                const tmpTarget = getTempPosElementBetween(document.getElementById('player-on-map'), targetOnMap);
                // показуєм початок битви
                showEventPopup(`${addEmoji('⚔️', '32px')}`, tmpTarget, {
                    color: '#ff0',
                    fontSize: '20px',
                    horizontalOffset: 5
                });

                let newEnemy = {...enemies[enemyIndex]};
                newEnemy.health = getEnemyMaxHealth(newEnemy);

                updateEnemyStats(newEnemy);
                elements.enemyEmoji.textContent = newEnemy.emoji;
                elements.enemyEmoji.style.filter = `grayscale(0%)`;
                
                showEnemy(newEnemy);
                setTimeout(function() {
                    startBattle(newEnemy);
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
            //addLog(`🚶 Ви перейшли на клітинку [${x}, ${y}]`, 'system');
            
            // Перевіряємо чи є тут щось цікаве
            checkCellContent(x, y);
            
            // рухаєм якогось воріженьку
            moveRandomEnemy();
            updateMap();
        }

        function getTempPosElementBetween(a, b) {
            const rectA = a.getBoundingClientRect();
            const rectB = b.getBoundingClientRect();

            // Знаходимо центр кожного елемента
            const centerAX = rectA.left + rectA.width / 2;
            const centerAY = rectA.top + rectA.height / 2;

            const centerBX = rectB.left + rectB.width / 2;
            const centerBY = rectB.top + rectB.height / 2;

            // Центр між центрами A і B
            const midX = (centerAX + centerBX) / 2;
            const midY = (centerAY + centerBY) / 2;

            // Позиціонування
            const middle = document.createElement('div');
            middle.style.position = 'absolute';
            // Розміщуємо новий div (в центрі між ними)
            middle.style.left = `${midX - middle.offsetWidth / 2}px`;
            middle.style.top = `${midY - middle.offsetHeight / 2}px`;
            middle.style.zIndex = '1000';
            middle.style.pointerEvents = 'none';

            document.body.appendChild(middle);
            // Видалення елемента після анімації
            setTimeout(() => { middle.remove();}, 50);
            return middle;
        }

        // Підбираємо артефакт
        function pickUpArtifact(x, y) {
            const artifact = gameMap[y][x].artifact;
            const targetOnMap = document.querySelector(`.map-cell[data-x="${x}"][data-y="${y}"]`);
            
            // Особливе повідомлення для еліксирів
            if (artifact.type.startsWith('potion')) {
                addLog(`✨ Ви знайшли потужний еліксир: ${artifact.emoji} <strong>${artifact.name}</strong> ⚗️ ${artifact.description}!`, 'artifact', '#4504ed');
            } else {
                let descArt = '';
                if (artifact.attack) descArt = `⚔️ +${artifact.attack} до атаки`;
                if (artifact.defense) descArt = `🛡️ +${artifact.defense} до захисту`;
                if (artifact.maxHealth) descArt = `❤️ +${artifact.maxHealth} до максимального здоров'я`;
                
                addLog(`✨ Ви знайшли артефакт: ${artifact.emoji} <strong>${artifact.name}</strong> ${descArt}!`, 'artifact', '#4504ed');

                // Анімація
                showEventPopup(`${addEmoji(artifact.emoji, '32px', artifact.subtype)}`, targetOnMap, {
                    fontSize: '40px',
                    horizontalOffset: 5
                });
            }
            
            player.inventory.push(artifact);
            // Видаляємо артефакт з карти
            gameMap[y][x] = { type: 'empty', emoji: emptyEmoji };
            player.position = { x, y };

            // якщо в гравця немає екіпу - має сенсу одразу брати підняту річ в руки
            if (player.equipment[artifact.type] == null && equipableTypes.includes(artifact.type)) {
                equipItem(player.inventory.length - 1);
            }
            
            updateMap();
            updateInventory();
        }

        function pickUpFruit(x, y) {
            const fruit = gameMap[y][x].fruit;
            const targetOnMap = document.querySelector(`.map-cell[data-x="${x}"][data-y="${y}"]`);

            const healAmount = Math.floor(player.maxHealth * fruit.healPercent);
            const newHealth = Math.min(player.maxHealth, player.health + healAmount);
            const actualHeal = newHealth - player.health;
            let overHealth = 0;

            if (fruit.healPercent > 0.9) {
                overHealth = Math.min(Math.floor(player.maxHealth / 2), healAmount - actualHeal);
                player.overpoweredHealth += Math.min(Math.floor(player.maxHealth / 2), overHealth + player.overpoweredHealth);
                player.health = player.maxHealth;
            } else {
                player.health = newHealth;
            }

            player.position = { x, y };
            
            // Анімація
            showEventPopup(`+${actualHeal}${addEmojiPlayer('❤️')}`, targetOnMap, {
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
            const targetOnMap = document.querySelector(`.map-cell[data-x="${x}"][data-y="${y}"]`);
            
            if (cell.type === 'treasure') {
                const goldFound = Math.floor(Math.random() * 10 * player.level) + 5;
                player.gold += goldFound;
                addLog(`💰 Ви знайшли скарб і отримали ${goldFound} золота!`, 'loot');

                showEventPopup(`+${goldFound}${addEmojiPlayer('💰')}`, targetOnMap, {
                    color: '#ff0',
                    fontSize: '20px'
                });
                
                // Видаляємо скарб
                gameMap[y][x] = { type: 'empty', emoji: emptyEmoji };
                updateStats();
                updateMap();
            } else if (cell.type == 'chest') {
                const isGoldenChest = cell.emoji == '📦👑';
                const chestName = isGoldenChest ? `<span style='color:gold; font-weight:bold'>Золотий Сундук</span>` : `сундук`;

                let goldFound = Math.floor(Math.random() * 5 * player.level) + 5;
                    goldFound = isGoldenChest ? goldFound * 3 : goldFound;
                let xpFound = Math.floor(Math.random() * 6 * player.level) + 5;
                    xpFound = isGoldenChest ? xpFound * 3 : xpFound;
                player.gold += goldFound;
                player.xp += xpFound;

                checkLevelUp();

                let messageChest = `🎁 Ви відкрили ${chestName} і отримали ${goldFound} золота та ${xpFound} досвіду!`;
                if (gameMap[y][x].artifact != null) {
                    player.inventory.push(gameMap[y][x].artifact);
                    messageChest = `🎁 Ви відкрили ${chestName} і отримали ${goldFound} золота, ${xpFound} досвіду та знайшли ${gameMap[y][x].artifact.emoji} ${gameMap[y][x].artifact.name}!`;

                    // якщо в гравця немає екіпу - має сенсу одразу брати підняту річ в руки
                    if (player.equipment[gameMap[y][x].artifact.type] == null && equipableTypes.includes(gameMap[y][x].artifact.type)) {
                        equipItem(player.inventory.length - 1);
                    }
                }

                addLog(messageChest, 'loot');

                // Анімація
                showEventPopup(`+${goldFound}${addEmojiPlayer('💰')}`, targetOnMap, {
                    color: '#ff0',
                    fontSize: '20px'
                });
                showEventPopup(`+${goldFound}${addEmojiPlayer('📈')}`, targetOnMap, {
                    color: '#ff0',
                    fontSize: '20px',
                    delay: 250,
                    horizontalOffset: -20,
                });
                showEventPopup(`${addEmoji(gameMap[y][x].artifact.emoji, '32px', gameMap[y][x].artifact.subtype)}`, targetOnMap, {
                    fontSize: '40px',
                    delay: 500,
                    horizontalOffset: 30
                });

                // Видаляємо сундук
                gameMap[y][x] = { type: 'empty', emoji: emptyEmoji };
                updateStats();
                updateInventory();
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

        // Додаємо сундучок на карту
        // Який має містити золото, досвід і рандомний предмет
        function spawnChest(isGold = false) {
            let x, y;
            let attempts = 0;

            // поки шо так
            isGold = Math.random() < 0.25;

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
                // обов'язково генеруємо якийсь предмет
                const item = generateItem(true, isGold ? 1 : -1);
                gameMap[y][x] = {
                    type: 'chest',
                    emoji: `${(isGold ? '📦👑' : '📦')}`,
                    artifact: item
                };
            }
        }

        // Додаємо артефакти на карту
        function spawnArtifacts(amount = -1) {
            const artifactCount = amount == -1 ? (2 + Math.floor(player.level / 3)) : amount;
            
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
            const treasureCount = amount == -1 ? 3 : amount;
            for (let i = 0; i < treasureCount; i++) {
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

        function spawnFruits(amount = -1) {
            // фруктів не може бути більше 12 штук одночасно
            const maxFuitsAtMap = 12;
            // Кількість фруктів залежить від рівня (або встановленого значення)
            let fruitCount = amount == -1 ? (2 + Math.floor(player.level / 3)) : amount;
            // Рахуєм к-сть харчів
            let currentFoods = []; for (i=0;i<gameMap.length;i++) { currentFoods.push(...gameMap[i].filter(food => food.type == 'fruit')); }
            // Якщо харчів забагато зменшуєм значення спавну
            fruitCount = (currentFoods.length + fruitCount) <= maxFuitsAtMap ? fruitCount : Math.min(0, maxFuitsAtMap - fruitCount);
            
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
            
            if (fruitCount > 0) addLog(`🍎 На карті з'явились нові наїдки! Вони відновлять відсоток вашого здоров'я.`, 'system');
            updateMap();
        }

        function respawnObstacles() {
            // Видаляємо 70-80% старих перешкод
            for (let y = 0; y < mapSize; y++) {
                for (let x = 0; x < mapSize; x++) {
                    if (gameMap[y][x].type === 'obstacle' && Math.random() < 0.75) {
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
                        emoji: obstacleType === 'tree' ? chooseOne(['🌳', '🌲']) : '🗻',
                        passable: false
                    };
                }
            }
        }

        // Функція для показу повідомлення
        function showGameMessage(header, message, duration = 0) {
            const modal = document.getElementById('game-modal');
            const messageHeader = document.getElementById('modal-header');
            const messageElement = document.getElementById('modal-message');
            const okButton = document.getElementById('modal-ok');
            
            messageHeader.innerHTML = header;
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

            okButton.focus();
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
            const growthRate = 1.6;
            const growSlow = 0.028;
            let growthSlow = ((level - 1) * growSlow);
                growthSlow = growthSlow > 0.995 ? 0.995 : growthSlow;

            const rawXp = baseXp * Math.pow(growthRate, level - 1);
            //const rawXp = baseXp * Math.pow(growthRate - growthSlow, level - 1);
            //const rawXp = baseXp * Math.pow(growthRate, level - 1) * (1 - growthSlow);
            //console.log([baseXp * Math.pow(growthRate, level - 1), rawXp, growthSlow]);*/

            // Автоматичне округлення до приємного масштабу
            let roundingStep = 10;
            if (rawXp >= 1000) {
                //console.log(['Math.log10(rawXp)', rawXp, Math.log10(rawXp), Math.floor(Math.log10(rawXp))]);
                roundingStep = Math.pow(10, Math.floor(Math.log10(rawXp)) - 1);
                //roundingStep = Math.pow(10, Math.floor(Math.log10(rawXp)));
                if (rawXp < roundingStep * 2) roundingStep /= 10;
            }

            if (level > 10) {
                return 3400 + (level - 10) * 1600;
            }
            /*if (level > 13) {
                return 10000 + (level - 13) * 4000;
            }*/

            return Math.round(rawXp / roundingStep) * roundingStep;
        }

        // функція розрахунку досвіду для рівня - комбінована
        function getXpByLevel2(level) {
            if (level <= 10) {
                // Експоненційне зростання на старті
                return Math.round(50 * Math.pow(1.6, level - 1) / 10) * 10;
            } else {
                // Плавне лінійне зростання після 10 рівня
                return 2500 + (level - 10) * 1500;
            }
        }

        function testlevelUp(minLevel = 1, maxLevel = 20) {
            let levelCounted = 1;
            let levelXpNextLast = 0;
            let levelXpNext = 0;
            for (i=0;i<=(maxLevel-minLevel);i++) {
                levelCounted = i+minLevel;
                levelXpNextLast = levelXpNext;
                levelXpNext = getXpByLevel(i+minLevel);
                //console.log(`${levelCounted};${levelXpNext};${levelXpNext-levelXpNextLast}`);
                console.log(`${levelXpNext}`);
            }
        }

        // Оновлюємо статистику гравця на екрані
        function updateStats() {
            elements.level.textContent = player.level;
            elements.gold.textContent = player.gold;
            elements.xp.textContent = player.xp;
            elements.xpToNext.textContent = player.xpToNext;
            elements.attack.textContent = player.attack;
            elements.attack.title = `БАЗА: ${player.baseAttack} + ДОД: ${player.attack-player.baseAttack}`;

            elements.defense.textContent = player.defense;
            elements.defense.title = `БАЗА: ${player.baseDefense} + ДОД: ${player.defense-player.baseDefense}`;

            // перерозраховуєм оверхелс
            const cleanMaxHealth = player.maxHealth - player.overpoweredHealth;
            elements.maxHealth.innerHTML
                = ((player.overpoweredHealth > 0 && player.health > cleanMaxHealth) ? `<span style="color: #8c1ce5;text-shadow: 1px 1px 2px black;font-weight: bold;">${player.health}</span>` : player.health) + '/'
                + (player.overpoweredHealth > 0 ? cleanMaxHealth : player.maxHealth);
            
            // Оновлюємо health bar гравця
            const playerHealthPercent = (player.health / player.maxHealth) * 100;
            elements.playerHealthBar.style.width = `${playerHealthPercent}%`;
            // чекаєм оверхелс
            if (player.overpoweredHealth > 0 && !elements.playerHealthBar.classList.contains('overpowered')) {
                elements.playerHealthBar.classList.add('overpowered');
                elements.playerHeartEmoji.classList.add('megahealth');
                elements.playerHeartEmoji.innerHTML = addEmoji(`💜`, '20px');
            } else if (player.overpoweredHealth < 1 && elements.playerHealthBar.classList.contains('overpowered')) {
                elements.playerHealthBar.classList.remove('overpowered');
                elements.playerHeartEmoji.classList.remove('megahealth');
                elements.playerHeartEmoji.innerHTML = addEmoji(`❤️`, '20px');
            }
            
            // Оновлюємо xp bar гравця
            const playerXpPercent = (player.xp / player.xpToNext) * 100;
            elements.playerXpBar.style.width = `${playerXpPercent}%`;
        }

        function signedValue(value) {
            if (value > 0) {
                return `+${value}`;
            } else {
                return `${value}`;
            }
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
                let itemClass = 'inventory-item';
                if (item.type === 'potion_health') itemClass += ' potion-health';
                else if (item.type === 'potion_attack') itemClass += ' potion-attack';
                else if (item.type === 'potion_defense') itemClass += ' potion-defense';
                
                let bonusText = '';

                if (item.attack) bonusText += ` ⚔️${signedValue(item.attack)}`;
                if (item.defense) bonusText += ` 🛡️${signedValue(item.defense)}`;
                if (item.maxHealth) bonusText += ` ❤️${signedValue(item.maxHealth)}`;
                if (item.critChance) bonusText += ` 💥${Math.floor(item.critChance*100)}%`;
                if (item.description) bonusText = ` ${item.description}`;
                
                const itemEmoji = addEmoji(item.emoji, '64px', typeof item.subtype != 'undefined' ? item.subtype : 0);
                itemElement.innerHTML = `
                    <div class="${itemClass}">[${index+1}]${item.name}<div>${itemEmoji}</div><div class="item-desc"><span class="artifact-bonus">${bonusText}</span></div></div>
                    <div class="item-actions">
                        <div class="item-action" onclick="useItem(${index})">${item.type.startsWith('potion') ? 'Випити' : 'Екіпірувати'}</div>
                        ${item.canSell !== false ? `<div class="item-action" onclick="sellItem(${index})">Продати (${Math.floor(item.value * 0.7)}💰)</div>` : ''}
                    </div>
                `;
                
                elements.inventoryItems.appendChild(itemElement);
            });
            
            elements.inventoryFullness.innerHTML = `(${player.inventory.length}${addEmoji('📦', '20px', undefined, 'vertical-align: text-bottom!important; margin-left: 4px;')})`;
            if (player.inventory.length === 0) {
                elements.inventoryItems.innerHTML = '<p>Інвентар порожній</p>';
                elements.inventoryFullness.innerHTML = '(Пусто)';
            }

            elements.gamblePrice.innerHTML = `${gamblingPrice()}${addEmoji('💰', '20px', undefined, 'vertical-align: text-bottom!important; margin-left: 4px;')}`;
        }

        // Оновлюємо слот обладнання
        function updateEquipmentSlot(slot) {
            const element = elements[`${slot}Slot`];
            if (player.equipment[slot]) {
                const item = player.equipment[slot];
                let bonusText = '';
                if (item.attack) bonusText += ` ⚔️${signedValue(item.attack)}`;
                if (item.defense) bonusText += ` 🛡️${signedValue(item.defense)}`;
                if (item.maxHealth) bonusText += ` ❤️${signedValue(item.maxHealth)}`;
                if (item.critChance) bonusText += ` 💥${Math.floor(item.critChance*100)}%`;
                
                let itemEmoji = addEmoji(item.emoji, '64px', item.subtype);
                element.innerHTML = `
                    <div class="inventory-item">
                        ${item.name}
                        <div>${itemEmoji}</div>
                        <div class="item-desc">
                            <span class="artifact-bonus">${bonusText}</span>
                        </div>
                    </div>
                `;
            } else {
                element.innerHTML = `
                    <div class="inventory-item">
                        Пусто
                        <div>${addEmoji(emptySlotsEquipmentsEmojies[slot], '64px', 0, 'filter: grayscale(1) invert(1);opacity: 0.1;')}</div>
                    </div>
                `;
            }
        }

        // знімаємо предмет
        function unequipItem(index) {
            const equipmentTypes = ['weapon', 'armor', 'ring', 'amulet', 'book', 'relic'];

            if (index < 0 || index > 5 || player.equipment[equipableTypes[index]] == undefined || player.equipment[equipableTypes[index]] == null) return;

            const item = player.equipment[equipableTypes[index]];
            player.inventory.push(item);
            player.equipment[equipableTypes[index]] = null;

            updateInventory();
            updateStats();
        }

        // Екіпіруємо предмет
        function equipItem(index) {
            const item = player.inventory[index];

            // врахуємо перерахунок співвідношення хп до макс хп
            let healthPercentage = Math.min(player.health / player.maxHealth, 1);
            let slot = item.type;
            let unequipedItem;
            
            // Якщо цей тип предмета вже екіпіровано, додаємо його в інвентар
            if (player.equipment[slot]) {
                player.inventory.push(player.equipment[slot]);
                unequipedItem = player.equipment[slot];
            }
            
            // Екіпіруємо новий предмет
            player.equipment[slot] = item;
            
            // Видаляємо предмет з інвентаря
            player.inventory.splice(index, 1);
            
            // Оновлюємо здоров'я, якщо змінилось максимальне значення
            // врахуємо перерахунок співвідношення хп до макс хп
            updateStats();
            if (item.maxHealth || (unequipedItem != null && unequipedItem.maxHealth)) {
                let currentHealth = player.health;
                // якщо рівень життя гравця до тимчасово збільшується, то робим гарну онімацію :)
                setTimeout(() => {
                    player.health = Math.floor(player.maxHealth * healthPercentage);
                    updateStats();
                }, currentHealth < player.maxHealth ? 250 : 0);
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
            showEventPopup(`+${sellPrice}${addEmojiPlayer('💰')}`, elements.playerEmoji, {
                color: '#ff0',
                fontSize: '20px'
            });
            updateStats();
            updateInventory();
        }

        // функція rarity від AI
        function getBiasedRarity(playerLevel, rarityBias = -1) {
            //console.log(rarityBias);
            // співвідношення
            const rarityTable = [
                { 'rarity': 1, 'playerLevel': 1 },
                { 'rarity': 2, 'playerLevel': 2 },
                { 'rarity': 3, 'playerLevel': 4 },
                { 'rarity': 4, 'playerLevel': 7 },
                { 'rarity': 5, 'playerLevel': 11 },
                { 'rarity': 6, 'playerLevel': 16 },
            ];

            // 1. Відфільтровуємо лише ті rarity, які <= рівню гравця
            const availableRarities = rarityTable.filter(entry => entry.playerLevel <= playerLevel);
            if (availableRarities.length === 0) return null; // якщо нічого не доступно

            // 2. Шукаємо найближчу rarity
            let closestEntry = availableRarities.reduce((prev, curr) =>
                Math.abs(curr.playerLevel - playerLevel) < Math.abs(prev.playerLevel - playerLevel)
                    ? curr
                    : prev
            );

            // 3. Вираховуємо rarityBiasTarget — зміщення на -2 rarity, якщо можливо
            const targetRarity = Math.max(1, closestEntry.rarity + rarityBias);
            const targetEntry = availableRarities.find(e => e.rarity === targetRarity);
            const biasLevel = targetEntry ? targetEntry.playerLevel : playerLevel;

            // 4. Розрахунок ваг
            const weightedTable = availableRarities.map(entry => {
                const distance = Math.abs(entry.playerLevel - biasLevel);
                const weight = 1 / (distance + 1);
                return { ...entry, weight };
            });

            const totalWeight = weightedTable.reduce((sum, entry) => sum + entry.weight, 0);
            let random = Math.random() * totalWeight;

            for (let entry of weightedTable) {
                random -= entry.weight;
                if (random <= 0) {
                    return entry.rarity;
                }
            }

            return weightedTable[0].rarity;
        }

        // Тест з текстовою гістограмою
        function testBiasedDistribution(playerLevel, iterations = 10000, bias = -1) {
            const results = {};

            for (let i = 0; i < iterations; i++) {
                const rarity = getBiasedRarity(playerLevel, bias);
                results[rarity] = (results[rarity] || 0) + 1;
            }

            console.log(`\n🎯 Player Level: ${playerLevel} | Bias: ${bias} (target rarity = -${Math.abs(bias)})`);
            for (const rarity of Object.keys(results).sort((a, b) => a - b)) {
                const count = results[rarity];
                const percentage = (count / iterations) * 100;
                const bar = '█'.repeat(Math.round(percentage));
                console.log(`Rarity ${rarity}: ${percentage.toFixed(2).padStart(5)}% | ${bar}`);
            }
        }

        function rarityTreshold(rarity, playerLevel) {
            const rarityTable = [
                { 'rarity': 1, 'playerLevel': 1 },
                { 'rarity': 2, 'playerLevel': 2 },
                { 'rarity': 3, 'playerLevel': 5 },
                { 'rarity': 4, 'playerLevel': 9 },
                { 'rarity': 5, 'playerLevel': 15 },
                { 'rarity': 6, 'playerLevel': 22 },
            ];

            // Знаходимо запис для запитаної рідкості
            const requested = rarityTable.find(r => r.rarity === rarity);

            if (requested && playerLevel >= requested.playerLevel) {
                // Якщо рівень достатній — повертаємо цю рідкість
                return rarity;
            }

            // Інакше — шукаємо максимально доступну рідкість для поточного рівня
            let available = rarityTable
                .filter(r => playerLevel >= r.playerLevel)
                .map(r => r.rarity);

            if (available.length === 0) {
                return null; // Якщо взагалі нічого не доступно
            }

            return Math.max(...available); // Найвища доступна рідкість
        }

        // Генеруємо випадковий предмет
        function generateItem(isForced = false, rarityBias = -1) {
            // 60% шанс отримати предмет
            if (Math.random() > 0.6 && !isForced) return null;
            
            // Вибираємо тип предмета (зброя, броня чи артефакт)
            const itemTypeRoll = Math.random();
            let itemPool;
            
            // 0-40% - weapons 41-80% - armors 81-91% - potions 92-100% - artifacts
            if (itemTypeRoll < 0.4) itemPool = weapons;
            else if (itemTypeRoll < 0.8) itemPool = armors;
            else if (itemTypeRoll < 0.91) itemPool = potions;
            else itemPool = artifacts;
            
            // Визначаємо рідкість на основі рівня гравця
            //let rarity = 1;
            let rarity = getBiasedRarity(player.level, rarityBias);
            /*    const rarityRoll = Math.random();
                
                if (rarityRoll > 0.98) rarity = 6; // 2% шанс на абсолютно легендарний
                else if (rarityRoll > 0.93) rarity = 5; // 5% шанс на легендарний
                else if (rarityRoll > 0.85) rarity = 4; // 8% шанс на міфічний
                else if (rarityRoll > 0.65) rarity = 3; // 20% шанс на рідкісний
                else if (rarityRoll > 0.4) rarity = 2; // 25% шанс на звичайний
                else rarity = 1; // 40% шанс на поширений

                // обмежуємо rarity за рівнем гравця (щоб не біло варіантів, коли випадає легендарка на 1-му рівні)
                const rarityTest = rarity;
                rarity = rarityTreshold(rarity, player.level);
                //console.log(`generateItem => in: ${rarityTest} => out: ${rarity}`);
            */
            // Фільтруємо предмети за рідкістю
            const availableItems = itemPool.filter(item => item.rarity <= rarity);

            if (availableItems.length === 0) {
                if (isForced) return generateItem(true, rarityBias);
                else return null;
            }
            
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
                addLog(`🧪 Ви випили ${item.emoji} ${item.name}! Ваша атака збільшилась на ${item.value}. (${player.baseAttack-item.value} => ${player.baseAttack})`, 'system');
                updateStats();
            }
            else if (item.type === 'potion_defense') {
                player.baseDefense += item.value;
                addLog(`🧪 Ви випили ${item.emoji} ${item.name}! Ваш захист збільшився на ${item.value}. (${player.baseDefense-item.value} => ${player.baseDefense})`, 'system');
                updateStats();
            }
            else if (item.type === 'potion_health') {
                player.bonusHealth += item.value;
                updateStats();
                addLog(`🧪 Ви випили ${item.emoji} ${item.name}! Ваше максимальне здоров'я збільшилось на ${item.value}. (${player.maxHealth-item.value} => ${player.maxHealth})`, 'system');

                setTimeout(() => {
                    player.health += item.value;
                    updateStats();
                }, 250);
            } else {
                // Якщо це не еліксир, екіпіруємо як звичайний предмет
                equipItem(index);
                return;
            }

            if (['potion_attack', 'potion_defense', 'potion_health'].includes(item.type)) {
                showEventPopup(`${addEmojiPlayer(item.emojiType)}+${item.value}`, elements.playerEmoji, {
                    color: item.color ? item.color : '#f00',
                });
            }
            
            // Видаляємо еліксир з інвентаря
            player.inventory.splice(index, 1);
            updateInventory();
        }

        // Генеруємо випадковий артефакт
        function generateArtifact() {
            // Визначаємо рідкість на основі рівня гравця
            //let rarity = 1;
            let rarity = getBiasedRarity(player.level);
            /*    const rarityRoll = Math.random();
                
                if (rarityRoll > 0.98) rarity = 6; // 2% шанс на абсолютно легендарний
                else if (rarityRoll > 0.93) rarity = 5; // 5% шанс на легендарний
                else if (rarityRoll > 0.85) rarity = 4; // 8% шанс на міфічний
                else if (rarityRoll > 0.65) rarity = 3; // 20% шанс на рідкісний
                else if (rarityRoll > 0.4) rarity = 2; // 25% шанс на звичайний
                else rarity = 1; // 40% шанс на поширений
                
                // обмежуємо rarity за рівнем гравця (щоб не біло варіантів, коли випадає легендарка на 1-му рівні)
                const rarityTest = rarity;
                rarity = rarityTreshold(rarity, player.level);*/
            //console.log(`generateArtifact => in: ${rarityTest} => out: ${rarity}`);

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
            let powerMultiplier = 1.6;
            
            if (enemy.elite) powerMultiplier = 2.5;
            if (enemy.boss) powerMultiplier = 3.4;
            
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
            enemy.baseMaxHealth = enemy.health;
            
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
                enemy.item = generateItem(false, enemy.boss ? 1 : (enemy.elite ? 0 : -1));
            }

            // з урахуванням item
            enemy.maxHealth = getEnemyMaxHealth(enemy);
            enemy.health = enemy.maxHealth;
            
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
                popupType: 'normal', // Час існування сповіщення ('normal' - 2s, 'slow' - 4s)
                horizontalOffset: 0, // Зсув точки спавна в px
            };
            
            // Об'єднуємо передані параметри з параметрами за замовчуванням
            options = { ...defaultOptions, ...options };
            
            // Функція, яка фактично створює і показує попап
            const createPopup = () => {
                const popupElement = document.createElement('div');
                let infoText = text;

                popupElement.className = options.popupType == 'slow' ? 'event-popup-slow' : 'event-popup';
                
                // Застосовуємо стилі
                popupElement.style.color = options.color;
                popupElement.style.fontSize = options.fontSize;
                
                if (options.isCritical) {
                    infoText += addEmojiPlayer('💥');
                    popupElement.style.fontWeight = 'bold';
                    popupElement.style.textShadow = '2px 2px 3px black';//'0 0 5px gold';
                }

                popupElement.innerHTML = `<div class="popup-info">${infoText}</div>`;
                
                // Позиціонування
                const rect = targetElement.getBoundingClientRect();
                popupElement.style.position = 'absolute';
                popupElement.style.left = `${options.horizontalOffset + rect.left + rect.width/2 - 20}px`;
                popupElement.style.top = `${rect.top - 20}px`;
                popupElement.style.zIndex = '1000';
                popupElement.style.pointerEvents = 'none';
                popupElement.style.animation = `popup ${(options.popupType == 'slow' ? 4 : 2)}s forwards`;
                
                document.body.appendChild(popupElement);
                
                // Видалення елемента після анімації
                setTimeout(() => {
                    popupElement.remove();
                }, options.popupType == 'slow' ? 4000 : 2000);
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

            enemy.health = getEnemyMaxHealth(enemy);

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
                let effectiveDefense = getEnemyDefense(enemy);

                // Перевірка на критичний удар
                if (player.equipment.weapon && Math.random() < player.equipment.weapon.critChance) {
                    isCritical = true;
                    effectiveDefense = Math.floor(getEnemyDefense(enemy) * 0.3); // Ігноруємо 70% захисту
                    critMessage = ` <span class="critical-hit">(КРИТИЧНИЙ УДАР! Ігнорує ${Math.ceil(getEnemyDefense(enemy) * 0.7)}🛡️)</span>`;
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
                    showEventPopup(`${addEmojiPlayer('💨','30px')}`, elements.enemyEmoji, {
                        color: '#f00',
                    });
                    playerDamage = 0;
                }
                
                // Хвороба знижує атаку на 75% але лише не критичні
                if (!isCritical && enemy.abilities.includes('disease') && Math.random() < 0.3) {
                    addLog(`🤢 ${enemy.emoji} ${enemy.type} послабив вашу атаку хворобою!`, 'enemy', '#124f12');
                    showEventPopup(`${addEmojiPlayer('🤢')}`, elements.enemyEmoji, {
                        color: '#f00',
                        horizontalOffset: -25
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
                }

                // Перевірка на перемогу
                if (enemy.health <= 0) {
                    // тепер рухаєм
                    player.isBattle = false;

                    let victoryMessage = `🎉 Ви перемогли ${enemy.emoji} ${enemy.type}!`;
                    if (enemy.boss) victoryMessage = `🏆 ВИ ПЕРЕМОГЛИ БОССА: ${enemy.type} 🎊`;
                    else if (enemy.elite) victoryMessage = `⭐ Ви перемогли елітного ${enemy.type}!`;
                    
                    addLog(victoryMessage, 'system');
                    elements.enemyEmoji.style.filter = `grayscale(100%)`;
                    //filter: grayscale(1);
                    updateEnemyStats(enemy);
                    
                    // Нагорода
                    player.gold += enemy.gold;
                    player.xp += enemy.xp;
                    addLog(`💰 Ви отримали ${enemy.gold} золота і ${enemy.xp} досвіду.`, 'loot');
                    
                    showEventPopup(`+${enemy.gold}${addEmojiPlayer('💰')}`, elements.playerEmoji, {
                        color: '#ff0',
                        fontSize: '20px',
                        delay: 500,
                        horizontalOffset: -25
                    });
                    showEventPopup(`+${enemy.xp}${addEmojiPlayer('📈')}`, elements.playerEmoji, {
                        color: '#88f',
                        fontSize: '18px',
                        delay: 750,
                        horizontalOffset: 15
                    });
                    
                    // Перевірка на предмет
                    if (enemy.item) {
                        player.inventory.push(enemy.item);
                        addLog(`🎁 ${enemy.item.emoji} Ви отримали: <strong>${enemy.item.name}</strong>!`, 'item', '#4504ed');

                        // якщо в гравця немає екіпу - має сенсу одразу брати підняту річ в руки
                        if (player.equipment[enemy.item.type] == null && equipableTypes.includes(enemy.item.type)) {
                            equipItem(player.inventory.length - 1);
                        }

                        updateInventory();

                        showEventPopup(`${addEmoji(enemy.item.emoji, '32px', enemy.item.subtype)}`, elements.playerEmoji, {
                            color: '#88f',
                            fontSize: '18px',
                            delay: 1000,
                        });
                    }
                    
                    // Видаляємо ворога з карти
                    const enemyIndex = enemies.findIndex(e => 
                        e.position.x === enemy.position.x && 
                        e.position.y === enemy.position.y
                    );
                    if (enemyIndex !== -1) {
                        enemies.splice(enemyIndex, 1);
                    }
                    
                    // Гравець зачистив локацію і отримує бонусяки
                    if (enemies.length < 1) {
                        spawnEnemies();
                        resetTerra();

                        showGameMessage(`Локацію зачищено`, `🎉 Ви зачистили локацію і отримуєте бонуси на новій локації!`, 0);

                        spawnArtifacts(2);
                        spawnChest();
                        spawnFruits(1);
                    }
                    
                    // Перевірка на новий рівень
                    checkLevelUp();
                    addLog(`---------------`, 'enemy');
                    
                    updateStats();
                    updateMap();
                    return;
                }

                // Ворог атакує (з урахуванням здібностей)
                setTimeout(() => {
                    let enemyDamage = Math.max(1, getEnemyAttack(enemy) - player.defense + Math.floor(Math.random() * 5) - 2);
                    fastEnemyStatus = false;
                    
                    // Спеціальні атаки
                    if (enemy.abilities.includes('strong') && Math.random() < 0.5) {
                        enemyDamage = Math.floor(enemyDamage * 1.3);
                        showEventPopup(`${addEmojiPlayer('💪')}`, elements.playerEmoji, {
                            color: '#fff',
                            horizontalOffset: -25
                        });
                    }
                    if (enemy.abilities.includes('fire_breath') && Math.random() < 0.25) {
                        const fireDamage = Math.max(1, Math.floor(enemyDamage * 0.5));
                        enemyDamage += fireDamage;
                        showEventPopup(`-${fireDamage}${addEmojiPlayer('🔥')}`, elements.playerEmoji, {
                            color: '#f00',
                            delay: 250,
                            horizontalOffset: -40
                        });
                        addLog(`[${iteration}] 🔥 ${enemy.emoji} ${enemy.type} використовує вогняне дихання (+${fireDamage} шкоди)!`, 'enemy');
                    }
                    if (enemy.abilities.includes('poison') && Math.random() < 0.25) {
                        const poisonDamage = Math.max(1, Math.floor(enemyDamage * 0.3));
                        enemyDamage += poisonDamage;
                        showEventPopup(`-${poisonDamage}${addEmojiPlayer('☣️')}`, elements.playerEmoji, {
                            color: '#0f0',
                            delay: 250,
                            horizontalOffset: -40
                        });
                        addLog(`[${iteration}] ☠️ ${enemy.emoji} ${enemy.type} отруює вас (+${poisonDamage} шкоди)!`, 'enemy');
                    }
                    if (enemy.abilities.includes('bloodsucker') && Math.random() < 0.3) {
                        const suckDamage = Math.max(1, Math.floor(enemyDamage * 0.333));
                        player.health -= suckDamage;
                        enemy.health = Math.min(enemy.maxHealth, enemy.health + suckDamage);
                        showEventPopup(`+${suckDamage}${addEmojiPlayer('🩸')}`, elements.enemyEmoji, {
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
                    if (enemy.abilities.includes('regeneration') && Math.random() < 0.4) {
                        const healAmount = Math.floor(enemy.maxHealth * 0.1);
                        enemy.health = Math.min(enemy.maxHealth, enemy.health + healAmount);
                        showEventPopup(`+${healAmount}${addEmojiPlayer('💚')}`, elements.enemyEmoji, {
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
                            horizontalOffset: -35
                        });
                        addLog(`[${iteration}] 💥 ${enemy.emoji} ${enemy.type} атакує вас двічі і завдає ${enemyDamage} x 2 шкоди.`, 'enemy', 'black');
                    } else {
                        addLog(`[${iteration}] 💥 ${enemy.emoji} ${enemy.type} атакує вас і завдає ${enemyDamage} шкоди.`, 'enemy');
                    }

                    updateStats();

                    // Гравець - мрець
                    if (player.health <= 0) {
                        // Показуєм кнопку відродження
                        elements.resurrectBtn.style.display = 'inline-block';
                        // Ховаєм кнопку гемблінга
                        elements.gambleBtn.style.display = 'none';

                        elements.playerEmoji.style.filter = `grayscale(100%)`;
                        addLog(`💀 Ви загинули в бою з ${enemy.emoji} ${enemy.type}!`, 'system');
                        showGameMessage(`Поразка`, `💀 Ви загинули в бою! Натисніть "Відродитись", щоб продовжити гру.`, 0);

                        showEventPopup(`${addEmoji('💀', '40px')}`, document.getElementById('player-on-map'), {
                            fontSize: '40px',
                        });
                        return;
                    }
                    
                    // Продовжуємо бій
                    setTimeout(battleStep, 1000);
                }, fastEnemyStatus ? 0 : 1000);
            }
            
            // Починаємо бій
            battleStep();
        }

        // Показуємо ворога
        function showEnemy(enemy) {
            elements.enemyView.style.display = 'block';
            //elements.enemyEmoji.textContent = enemy.emoji;
            elements.enemyEmoji.innerHTML = addEmoji(enemy.emoji, '64px');
            elements.enemyEmoji.style.color = enemy.color;
            
            updateEnemyStats(enemy);
            
            let enemyTitle = enemy.type;
            if (enemy.boss) enemyTitle = `БОС: ${enemy.type} 💀`;
            else if (enemy.elite) enemyTitle = `Елітний ${enemy.type} ⚡`;
            
            addLog(`---------------`, 'enemy');
            const enemyAttack = enemy.attack < getEnemyAttack(enemy) ? `<strong class="upgraded-stat">${getEnemyAttack(enemy)}</strong>` : getEnemyAttack(enemy);
            const enemyDefense = enemy.defense < getEnemyDefense(enemy) ? `<strong class="upgraded-stat">${getEnemyDefense(enemy)}</strong>` : getEnemyDefense(enemy);
            const enemyMaxHealth = enemy.baseMaxHealth < getEnemyMaxHealth(enemy) ? `<strong class="upgraded-stat">${getEnemyMaxHealth(enemy)}</strong>` : getEnemyMaxHealth(enemy);

            addLog(`⚔️ Ви зустріли ${enemy.emoji} <strong>${enemyTitle}</strong> 🗡:${enemyAttack} | 🛡:${enemyDefense} | ❤:${enemyMaxHealth} !`, 'enemy');
            
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
            const attackEmoji = addEmoji('⚔️', '20px');
            const defenseEmoji = addEmoji('🛡️', '20px');
            const healthEmoji = addEmoji('❤️', '20px');

            const enemyAttack = enemy.attack < getEnemyAttack(enemy) ? `<strong class="upgraded-stat">${getEnemyAttack(enemy)}</strong>` : getEnemyAttack(enemy);
            const enemyDefense = enemy.defense < getEnemyDefense(enemy) ? `<strong class="upgraded-stat">${getEnemyDefense(enemy)}</strong>` : getEnemyDefense(enemy);
            const enemyMaxHealth = enemy.baseMaxHealth < getEnemyMaxHealth(enemy) ? `<strong class="upgraded-stat">${getEnemyMaxHealth(enemy)}</strong>` : getEnemyMaxHealth(enemy);

            elements.enemyStats.innerHTML = `${attackEmoji}: ${enemyAttack} | ${defenseEmoji}: ${enemyDefense} | ${healthEmoji}: ${(enemy.health >= 0 ? enemy.health : 0)}/${enemyMaxHealth}`;
            
            // Оновлюємо health bar ворога
            const enemyHealthPercent = ((enemy.health >= 0 ? enemy.health : 0) / getEnemyMaxHealth(enemy)) * 100;
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
                
                addLog(`🌟 Вітаємо! Ви досягли ${player.level} рівня! Ваші характеристики зросли.`, 'system');
                showEventPopup(`🌟 ${player.level} 🌟`, document.getElementById('player-on-map'), {
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
                spawnChest();
                return true;
            }
            return false;
        }

        function gamblingPrice() {
            return player.level * 50;
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

        // щоб кудись вирачати гроші
        function gamble() {
            if (player.gold < gamblingPrice()) {
                addLog(`🎰❌ У вас немає ${gamblingPrice()} 💰 золота для гемблінгу!`, 'system');
                showEventPopup(`${addEmoji('❌', '40px')}`, elements.gambleBtn);
                return;
            }

            player.gold -= gamblingPrice();
            const localRandom = Math.random();

            // 31% - art / 23% - chest / 23% - fruits / 15% - xp / 8% - jackpot 
            if (localRandom < 0.31) {
                // 31% артефакти
                showEventPopup(`${addEmoji('🔮', '40px')}`, elements.gambleBtn);
                spawnArtifacts(1);

                addLog(`🎰🔮 Удача! На карті з'явився артефакт!`, 'loot');
            } else if (localRandom < 0.54) { 
                // 23% сундук
                showEventPopup(`${addEmoji('📦', '40px')}`, elements.gambleBtn);
                spawnChest();

                addLog(`🎰📦 Удача! На карті з'явився сундук!`, 'loot');
            } else if (localRandom < 0.77) {
                // 23% фрукт
                showEventPopup(`${addEmoji('🍎', '40px')}`, elements.gambleBtn);
                setTimeout(() => {
                    spawnFruits(1);
                }, 100);

                addLog(`🎰🍎 На карті з'явився харч!`, 'loot');
            } else if (localRandom < 0.92) {
                // 15% - 25% of level
                //const addingXp = Math.round(player.xpToNext * 0.25);
                const randomXpParam = Math.random();
                const maxXpOnLevel = 24 * player.level + (5 + player.level * 4);
                const minXpOnLevel = Math.floor(maxXpOnLevel * 0.5);

                const addingXp = rand(minXpOnLevel, maxXpOnLevel);
                showEventPopup(`${addEmoji('📈', '40px')}`, elements.gambleBtn);

                player.xp += addingXp;
                checkLevelUp();
                updateStats();

                showEventPopup(`+${addingXp}${addEmojiPlayer('📈')}`, elements.playerEmoji, {
                    color: '#88f',
                    fontSize: '18px',
                    delay: 50,
                });

                addLog(`🎰📈 Ви нічого не виграли, але отримали ${addingXp} досвіду!`, 'loot');
            } else {
                // решта золотішко
                const jackPot = Math.floor(gamblingPrice() * rand(2, 3));
                showEventPopup(`${addEmoji('💰', '40px')}`, elements.gambleBtn);

                player.gold += jackPot;

                showEventPopup(`+${jackPot}${addEmojiPlayer('💰')}`, elements.playerEmoji, {
                    color: '#ff0',
                    fontSize: '20px',
                    delay: 50,
                });

                addLog(`🎰💰 Ви виграли ${jackPot} грошей!`, 'loot');
            }

            updateMap();
            updateStats();
        }

        // Відродження
        function resurrect() {
            if (player.health > 0) return;

            // можем рухать
            player.isBattle = false;

            // Ховаємо кнопку Відродження
            elements.resurrectBtn.style.display = 'none';
            // Показуєм кнопку гемблінга
            elements.gambleBtn.style.display = 'inline-block';

            elements.playerEmoji.style.filter = `grayscale(0%)`;
            // втрачаєте 25% золота і 20% досвіду рівня
            const lostGold = Math.round(player.gold * 0.25);
            let lostXp = Math.round(player.xpToNext * 0.2);
            lostXp = lostXp >= player.xp ? player.xp : lostXp;

            addLog(`📈 Ви втратили ${lostXp} досвіду!`, 'system', 'red');
            addLog(`💰 Ви втратили ${lostGold} золота!`, 'system', 'red');

            showGameMessage(`Відродження`, `Ви відродились та частково відновили власні сили, але довелось витратили 📈 ${lostXp} досвіду і 💰 ${lostGold} золота, щоб повернути Вас до життя!`, 0);

            player.gold -= lostGold;
            player.xp -= lostXp;

            // скидуєм оверхелс
            player.overpoweredHealth = 0;
            player.health = Math.ceil(player.maxHealth * 0.5);
            addLog('⚡ Ви відродились і частково відновили здоров\'я!', 'system');

            // спавн фрукта після смерті трошки покращить становище в бою
            spawnFruits(1);

            // Оновлюємо health bar
            updateStats();
            
            // Вороги також відпочивають (респавняться)
            enemies = [];
            respawnObstacles();

            spawnEnemies();
            resetTerra();
            updateMap();
        }

        function toogleInventory() {
            // змінюєм статус "Гравець в інвентарі"
            player.inInventory = !player.inInventory;

            // відображаєм інвентар
            elements.inventory.style.display = player.inInventory ? 'block' : 'none';
            // ховаєм мапу
            elements.map.style.display = player.inInventory ? 'none' : 'grid';

            // ховаєм кнопку інвентаря
            elements.inventoryBtn.style.display = player.inInventory ? 'none' : 'inline-block';
            // показуєм кнопку мапи
            elements.mapBtn.style.display = player.inInventory ? 'inline-block' : 'none';
        }

        function beginAll() {
            // Обробники подій
            elements.healBtn.addEventListener('click', heal);
            elements.gambleBtn.addEventListener('click', gamble);
            elements.resurrectBtn.addEventListener('click', resurrect);

            elements.inventoryBtn.addEventListener('click', toogleInventory);
            elements.mapBtn.addEventListener('click', toogleInventory);
            elements.closeInventoryBtn.addEventListener('click', toogleInventory);

            // Глобальні функції для виклику з HTML
            window.equipItem = equipItem;
            window.sellItem = sellItem;

            // buttons 
            document.addEventListener("keydown", (e) => {
                // player moving
                if (!player.inInventory) {
                    if (e.code === "ArrowUp") movePlayer(player.position.x, player.position.y - 1);
                    if (e.code === "ArrowRight") movePlayer(player.position.x + 1, player.position.y);
                    if (e.code === "ArrowDown") movePlayer(player.position.x, player.position.y + 1);
                    if (e.code === "ArrowLeft") movePlayer(player.position.x - 1, player.position.y);
                }
                // gambling
                if (e.code === "KeyG") gamble();
                if (e.code === "KeyI") toogleInventory();

                // resurrect
                if (e.code === "KeyR" && player.health < 1) { resurrect(); }

                // items manupulations
                if (['Digit1', 'Digit2', 'Digit3', 'Digit4', 'Digit5', 'Digit6', 'Digit7', 'Digit8' ,'Digit9'].includes(e.code)) {
                    
                    //console.log([e.code, e.shiftKey, e.altKey]);

                    const itemIndex = parseInt(e.code.split("Digit")[1]) - 1;

                    // якщо тицнем цифру із Shift - то автоматично продаєм її, але лише якщо гравець дивиться у інвентар
                    if (e.shiftKey && player.inventory[itemIndex] != null && player.inInventory) sellItem(itemIndex);
                    // якщо тицнем цифру із Alt - то знімаєм вдягнену річ (1-зброя / 2-броня / 3-кільце / 4-амулет / 5-книга / 6-реліквія)
                    else if (e.altKey) unequipItem(itemIndex);
                    // якщо просто тиснем цифру з рюкзака, то вона вдягнеться/використається
                    else if (player.inventory[itemIndex] != null) useItem(itemIndex);
                }
            });

            // Оновлене початкове повідомлення
            addLog('🌈 Ласкаво просимо в Міні RPG!', 'system');
            addLog('🧪 Тепер у світі можна знайти 3 види еліксирів:', 'system');
            addLog('🗺️ Клацайте на клітинки карти, щоб рухатись.', 'system');
            
            // Ініціалізація гри
            initMap();
            
            updateStats();
            updateInventory();

            emojiReplace();

            elements.enemyEmoji.innerHTML = addEmoji('👺', '64px', undefined, 'filter: grayscale(1) invert(1); opacity: 0.1;');
        }
    </script>
    {/ignore}