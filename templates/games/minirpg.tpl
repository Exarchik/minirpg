    {ignore}
    <script>
        let icons = {};
        let maskIcons = {};
        // отримуємо всі іконкі з атласу. дякую: https://www.codeandweb.com/free-sprite-sheet-packer
        Promise.all([
            fetch('/templates/img/minirpg/clay/spritesheet.json').then(res => res.json()),
            fetch('/templates/img/minirpg/clay/_mask-spritesheet.json').then(res => res.json())
        ]).then(([data, dataMask]) => {
            // спочатку підгружаєм всі іконки
            icons = data;
            maskIcons = dataMask;
            // лише потім стартуєм ВСЬО!
            beginAll();
        }).catch(err => {
            console.error('Помилка при завантаженні JSON:', err);
        });
    </script>
    {/ignore}
    <style>
        @font-face {
            font-family: 'MiniRPGFOnt';
            src: url('/templates/css/fonts/AvertaDemoPE-Regular.woff2') format('woff2');
            font-weight: normal;
            font-style: normal;
        }

        * {
            font-family: 'MiniRPGFOnt', monospace !important;
        }
        body {
            /*font-family: 'Courier New', monospace;*/
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

        #levels {
            height: 354px;
        }

        #levels .levels-selector {
            width: 100px;
            height: 40px;
            white-space: nowrap;
            background-color: #0080ff;
            border-radius: 5px;
            position: relative;
            padding: 0px 0px;
            text-align: center;
            cursor: pointer;
            display: inline-block;
            margin: 2px;
        }
        #levels .levels-selector.completed {
            background-color: green;
        }
        #levels .levels-selector:hover,
        #levels .levels-selector.completed:hover,
        #levels .levels-selector:focus,
        #levels .levels-selector.completed:focus {
            background-color: #ff9600;
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
            position: relative;
            z-index: 1;
            width: 64px;
            height: 64px;
            background-image: url('/templates/img/minirpg/clay/spritesheet.png');
            background-size: auto; /* або вказати розміри атласу */
        }
        .emoji-sprite.emoji-mask {
            background-image: url('/templates/img/minirpg/clay/_mask-spritesheet.png');
            position: absolute;
            z-index: 2;
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
        .modal.danger .modal-header {
            border: 2px solid #ff0000;
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
        .modal.danger .modal-content {
            border: 2px solid #ff0000;
        }

        .modal .modal-button {
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
        .modal.danger .modal-button {
            background-color: red;
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

        #gambleBtn.tickets {
            background-color: #005aff;
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

        #storeBtn {
            background-color: #b53b3b;
        }

        #resurrectBtn:hover {
            background-color: #A52A2A;
        }

        #resurrectBtn:active {
            transform: scale(0.98);
        }

        #log {
            height: 156px;
            overflow-y: scroll;
            border: 1px solid #444;
            padding: 5px 10px;
            margin-top: 25px;
            background-color: #252525;
            line-height: 1.5;
            font-size: 14px;
        }
        #log.log-shorted {
            height: 50px;
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
            height: 72px;
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
        #inventory, #store {
            margin-top: 15px;
            padding: 10px;
            background-color: #252525;
            border-radius: 5px;
            /*overflow-y: scroll;*/
            /*height: 435px;*/
            height: 465px;
            position: relative;
        }
        #inventory #inventory-items {
            overflow-y: auto;
            height: 100%;
        }
        #store-items {
            overflow-y: auto;
            height: 91%;
            margin-top: 6px;
        }

        /*new shop visualize*/
        #inventory-items .item-slot,
        #store-items .item-slot {
            display: inline-grid;
            margin: 5px;
            padding: 5px;
            background-color: #444;
            border-radius: 3px;
            cursor: pointer;
            position: relative;
            text-align: center;
            width: 30%;
            min-height: 90px;
        }
        #inventory-items .item-slot .item-name,
        #store-items .item-slot .item-name {
            font-size: 15px;
            z-index: 10;
            position: relative;
            text-align: right;
            top: -6px;
            height: 23px;
        }
        #inventory-items .item-slot .item-image,
        #store-items .item-slot .item-image {
            filter: drop-shadow(6px 6px 6px #000000aa);
            /* width: 49%; */
            /* display: inline-block; */
            position: absolute;
            right: -5px;
            top: 27px;
            z-index: 20;
            pointer-events: none;
        }
        #inventory-items .item-slot .item-desc,
        #store-items .item-slot .item-desc {
            padding: 0 0 10px 5px;
            width: 100%;
            position: relative;
            text-align: left;
            border-top: inherit;
        }

        #inventory-items .item-slot .item-type-subinfo,
        #store-items .item-slot .item-type-subinfo {
            position: absolute;
            top: -6px;
            left: 3px;
            right: inherit;
            bottom: inherit;
            filter: brightness(1.2) drop-shadow(1px 1px 0px black);
        }

        #inventory-items .item-slot .item-desc.item-price::before,
        #store-items .item-slot .item-desc.item-price::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            height: 1px;
            width: 100%;
            background: linear-gradient(to left, #00000000 0%, #00000000 40%, #000000 100%);
        }
        #inventory-items .item-slot .item-desc.item-price,
        #store-items .item-slot .item-desc.item-price {
            padding-bottom: 0px !important;
        }
        #inventory-items .item-slot .item-actions,
        #store-items .item-slot .item-actions {
            top: 70%;
        }
        #inventory-items .item-slot.item-weapon,
        #store-items .item-slot.item-weapon {
            background: radial-gradient(at 90% 60%, rgb(255 102 0 / 64%) 0%, rgb(47 1 1 / 33%) 100%);
        }
        #inventory-items .item-slot.item-armor,
        #store-items .item-slot.item-armor {
            background: radial-gradient(at 90% 60%, rgb(0 255 34 / 44%) 0%, rgba(59, 93, 56, 0.33) 100%);
        }
        #inventory-items .item-slot.item-ring,
        #store-items .item-slot.item-ring {
            background: radial-gradient(at 90% 60%, rgb(255 253 0 / 40%) 0%, rgba(87, 89, 7, 0.33) 100%);
        }
        #inventory-items .item-slot.item-amulet,
        #store-items .item-slot.item-amulet {
            background: radial-gradient(at 90% 60%, rgb(0 190 255 / 50%) 0%, rgb(2 33 43 / 45%) 100%);
        }
        #inventory-items .item-slot.item-book,
        #store-items .item-slot.item-book {
            background: radial-gradient(at 90% 60%, rgb(0 99 235 / 56%) 0%, rgb(5 0 75 / 33%) 100%);
        }
        #inventory-items .item-slot.item-relic,
        #store-items .item-slot.item-relic {
            background: radial-gradient(at 90% 60%, rgb(187 0 255 / 47%) 0%, rgb(38 0 41 / 33%) 100%);
        }
        #inventory-items .item-slot.item-potion_attack,
        #store-items .item-slot.item-potion_attack {
            background: radial-gradient(at 90% 60%, rgb(10 255 0 / 57%) 0%, rgb(0 170 255 / 32%) 50%, rgb(79 11 11 / 36%) 100%);
        }
        #inventory-items .item-slot.item-potion_defense,
        #store-items .item-slot.item-potion_defense {
            background: radial-gradient(at 90% 60%, rgb(0 49 255 / 57%) 0%, rgb(0 170 255 / 32%) 50%, rgb(79 11 11 / 36%) 100%);
        }
        #inventory-items .item-slot.item-potion_health,
        #store-items .item-slot.item-potion_health {
            background: radial-gradient(at 90% 60%, rgb(255 0 0 / 57%) 0%, rgb(0 170 255 / 32%) 50%, rgb(79 11 11 / 36%) 100%);
        }

        /* magic */
        .item-slot.magic .item-name, .inventory-item.magic .item-name { text-shadow: 2px 2px 0 black; }
        .item-slot.magic.magic-1 .item-name, .inventory-item.magic.magic-1 .item-name { color: #0f0 !important; }
        .item-slot.magic.magic-2 .item-name, .inventory-item.magic.magic-2 .item-name { color: #3e92ed !important; font-weight: bold; }
        .item-slot.magic.magic-3 .item-name, .inventory-item.magic.magic-3 .item-name { color: #ed983e !important; font-weight: bold; text-shadow: 3px 3px 2px black !important;}

        /* cursed */
        .item-slot.cursed {
            background: radial-gradient(at 100% 100%, rgb(0 0 0) 0%, rgb(145 145 145) 100%) !important;
        }
        .item-slot.cursed .item-subinfo-up, .item-slot.cursed .item-subinfo {
            color: #222;
        }

        #closeInventoryBtn, #closeStoreBtn {
            position: absolute;
            z-index: 20;
            right: 10px;
            top: 0px;
            padding: 2px 3px 2px 3px;
            color: #000;
            background-color: #555;

            /*hide*/
            display: none;
        }

        #button-store-wrapper {
            display: inline-block;
            position: relative;
        }
        #button-store-wrapper.disabled:after {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            width: 100%;
            height: 2px;
            background: red;
            transform: rotate(5deg);
            transform-origin: center;
            pointer-events: none;
        }
        #updateStoreBtn {
            display: inline-block;
            padding: 4px 6px;
            background-color: transparent;
            margin: 0 0 0 10px;
        }
        #updateStoreBtn.tickets, #slot-button.tickets {
            background-color: #005aff;
        }
        #button-store-wrapper.disabled button#updateStoreBtn {
            filter: grayscale(1);
        }
        .inventory-item {
            /**/
        }
        .inventory-item:hover .item-image {
            scale: 1.1;
        }

        .inventory-item.cursed .item-name {
            color: #ffffff !important;
            text-shadow: 2px 2px 2px #000000 !important;
            filter: initial !important;
        }
        .item-name {
            font-size: 15px;
            z-index: 10;
            position: relative;
            text-align: right;
            top: -5px;
            height: 23px;
        }
        .item-image {
            filter: drop-shadow(6px 6px 6px #000000aa);
            position: absolute;
            right: 8px;
            top: 34px;
        }

        .item-image-background {
            position: absolute;
            filter: opacity(0.25) blur(1.5px) grayscale(0) brightness(1);
            scale: 2;
            z-index: 0;
            mix-blend-mode: soft-light;
        }
        .item-image-background.equipment {
            clip-path: rect(3px 70px 87% 13px);
        }
        .item-image-background.store, .item-image-background.inventory {
            clip-path: rect(3px 70px 74% 13px);
        }

        .item-desc {
            padding: 0 0 10px 5px;
            width: 100%;
            position: relative;
            text-align: left;
            border-top: inherit;
        }
        .item-desc.item-price {
            border-top: 1px inset #777;
        }
        .item-subinfo, .item-subinfo-up {
            color: #666;
            font-size: 10px;
            position: absolute;
            bottom: 2px;
        }
        .item-subinfo-up {
            bottom: 14px;
        }
        .item-type-subinfo {
            position: absolute;
            top: -4px;
            left: 4px;
            filter: brightness(1.2) drop-shadow(1px 1px 0px black);
        }
        /*.item-type-subinfo.weapon {
            filter: brightness(1.5) contrast(2) hue-rotate(339deg);
        }
        .item-type-subinfo.ring {
            filter: brightness(1.5) contrast(1.2);
        }*/
        .item-slot {
            display: inline-block;
            margin: 5px;
            padding: 5px;
            background-color: #444;
            border-radius: 3px;
            cursor: pointer;
            position: relative;
            text-align: center;
            width: 30%;
        }
        .item-slot.not-enough-gold {
            filter: grayscale(1) brightness(0.5);
        }
        .item-slot:hover {
            /*background-color: #555;*/
        }
        .item-slot:hover .item-image {
            scale: 1.1;
        }
        .item-weapon {
            background: radial-gradient(at 90% 90%, rgb(255 102 0 / 64%) 0%, rgb(47 1 1 / 33%) 100%);
        }
        .item-armor {
            background: radial-gradient(at 90% 90%, rgb(0 255 34 / 44%) 0%, rgba(59, 93, 56, 0.33) 100%);
        }
        .item-ring {
            background: radial-gradient(at 90% 90%, rgb(255 253 0 / 40%) 0%, rgba(87, 89, 7, 0.33) 100%);
        }
        .item-amulet {
            background: radial-gradient(at 90% 90%, rgb(0 190 255 / 50%) 0%, rgb(2 33 43 / 45%) 100%);
        }
        .item-book {
            background: radial-gradient(at 90% 90%, rgb(0 99 235 / 56%) 0%, rgb(5 0 75 / 33%) 100%);
        }
        .item-relic {
            background: radial-gradient(at 90% 90%, rgb(187 0 255 / 47%) 0%, rgb(38 0 41 / 33%) 100%);
        }
        .item-slot.item-potion_attack {
            background: radial-gradient(at 90% 90%, rgb(10 255 0 / 57%) 0%, rgb(0 170 255 / 32%) 50%, rgb(79 11 11 / 36%) 100%);
        }
        .item-slot.item-potion_defense {
            background: radial-gradient(at 90% 90%, rgb(0 49 255 / 57%) 0%, rgb(0 170 255 / 32%) 50%, rgb(79 11 11 / 36%) 100%);
        }
        .item-slot.item-potion_health {
            background: radial-gradient(at 90% 90%, rgb(255 0 0 / 57%) 0%, rgb(0 170 255 / 32%) 50%, rgb(79 11 11 / 36%) 100%);
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
            z-index: 15;
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
            text-align: left;
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
            background-color: #252525;
            padding: 5px;
            border-radius: 5px;
        }
        .equipment-slot {
            display: block;
            padding: 5px;
            /*background-color: #3a3a3a;*/
            border-radius: 3px;
            min-width: 60px;
            text-align: center;
            position: relative;
        }
        .equipment-slot:hover .item-actions {
            display: block;
        }
        #equipment .equipment-slot {
            min-height: 108px;
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
            justify-self: left /*center*/;
        }
        .map-cell.incognita-cell {
            background-color: #333;
            background-image: none;
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
            background-image: url(/templates/img/minirpg/clay/floor.png)
        }
        .map-cell:not(.sight-cell) {
            opacity: 0.5;
            filter: grayscale(1) blur(1px);
            animation: initial;
        }
        .map-cell:hover {
            background-color: #555;
        }
        .visited-cell {
            background-color: #3a3a3a;
            filter: brightness(1.15);
        }
        .player-cell {
            background-color: #55f;
            animation: pulse 1.5s infinite;
        }
        .player-cell:hover{
            background-color: #55f;
        }
        .enemy-cell, .elite-cell, .boss-cell {
            animation: pulse 1.5s infinite;
            z-index: 8;
        }
        .enemy-cell .emoji-sprite {
            filter: brightness(1.2) drop-shadow(0px 0px 6px rgb(255, 181, 85));
        }
        .elite-cell .emoji-sprite {
            filter: brightness(1.2) drop-shadow(0px 0px 6px rgb(240, 78, 78));
        }
        .boss-cell .emoji-sprite {
            filter: brightness(1.2) drop-shadow(0px 0px 6px rgb(255, 0, 0));
        }

        .artifact-cell {
            animation: pulse 1.5s infinite;
            z-index: 10;
        }
        .artifact-cell .emoji-sprite {
            filter: drop-shadow(0 0 7px #f8f);
        }
        .store-cell {
            animation: pulse 1.5s infinite;
            z-index: 2;
        }
        .store-cell .emoji-sprite {
            filter: saturate(1.1) drop-shadow(0px 0px 6px green);
        }
        .exit-cell {
            background-color: #111;
        }
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        @keyframes glow {
            0% { filter: drop-shadow(0 0 2px #f8f); }
            50% { filter: drop-shadow(0 0 7px #f8f); }
            100% { filter: drop-shadow(0 0 2px #f8f); }
        }
        #controls {
            margin-top: 10px;

            /* hide */
            display: none;
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
        .artifact-bonus.store-price {
            position: relative;
        }
        .artifact-bonus.store-price.store-price-old:after {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            width: 100%;
            height: 3px;
            background: red;
            transform: rotate(20deg);
            transform-origin: center;
            pointer-events: none;
        }
        .artifact-bonus.store-price.store-price-promo {
            font-weight: bold;
            color: #00ff00;
            font-size: 16px;
            position: relative;
            left: 5px;
        }
        .item-slot .promo-tag {
            position: absolute;
            top: 0px;
            left: -7px;
            color: white;
            font-size: 12px;
            font-weight: bold;
            padding: 2px 6px;
            transform: rotate(-15deg);
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.4);
            clip-path: polygon(0 0, 100% 0, 100% 100%, 8% 100%);
            pointer-events: none;
            z-index: 30;
        }
        .item-slot .promo-tag.promo-95 {
            background: #ff0000;
        }
        .item-slot .promo-tag.promo-75 {
            background: #ff7800;
        }
        .item-slot .promo-tag.promo-50 {
            background: #0aab27;
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
        .potion-health { color: #ffb300; }
        .potion-attack { color: #0f0; }
        .potion-defense { color: #00ceff; }
        .potion-cell {
            /*background-color: #79c4f7;
            animation: potion-glow 1s infinite alternate;*/
            animation: pulse 1.5s infinite alternate;
        }
        .potion-cell .emoji-sprite {
            filter: drop-shadow(0px 0px 3px #79c4f7);
        }
        @keyframes potion-glow {
            from { box-shadow: 0 0 5px #79c4f7; }
            to { box-shadow: 0 0 20px #79c4f7; }
        }
        
        /* Анімація атаки */
        @keyframes shake {
            0% { transform: translate(1px, 0); filter: sepia(0);/* filter: brightness(1) drop-shadow(1px 1px red) drop-shadow(-1px -1px blue); */}
            25% { transform: translate(-2px, 0); filter: sepia(0.5);/* filter: brightness(1.2) drop-shadow(2px 2px red) drop-shadow(-2px -2px blue); */}
            50% { transform: translate(2px, 0); filter: sepia(1);/* filter: invert(0,5) brightness(1.4) drop-shadow(3px -3px red) drop-shadow(3px -3px blue); */}
            75% { transform: translate(-1px, 0); filter: sepia(0.5);/* filter: brightness(1.2) drop-shadow(2px 2px red) drop-shadow(-2px -2px blue); */}
            100% { transform: translate(0, 0); filter: sepia(0); filter: brightness(1) drop-shadow(-1px -1px red) drop-shadow(1px 1px blue); }
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
            /*border-radius: 50%;*/
            z-index: 10;
        }

        .chest-cell, .chest-cell:hover, .money-cell, .money-cell:hover {
            animation: fruit-pulse 2s infinite;
            border-radius: 50%;
            z-index: 9;
            color: #fdac0096;
            background-color: #fdac0096;
        }
        .chest-cell .emoji-sprite {
            filter: brightness(1.1) drop-shadow(0px 0px 6px #ffaa00);
        }
        .money-cell .emoji-sprite {
            filter: brightness(1.1) drop-shadow(0px 0px 6px #b3ff63)
        }

        @keyframes fruit-pulse {
            0% { transform: scale(1); /*box-shadow: 0 0 5px currentColor;*/ }
            50% { transform: scale(1.1); /*box-shadow: 0 0 15px currentColor;*/ }
            100% { transform: scale(1); /*box-shadow: 0 0 5px currentColor;*/ }
        }

        .map-cell.fruit-cell[data-fruit="25"] .emoji-sprite { filter: brightness(1.2) drop-shadow(0px 0px 6px #ff5555); }
        .map-cell.fruit-cell[data-fruit="50"] .emoji-sprite { filter: brightness(1.2) drop-shadow(0px 0px 6px #ffaa00); }
        .map-cell.fruit-cell[data-fruit="100"] .emoji-sprite { filter: brightness(1.2) drop-shadow(0px 0px 6px #673ab7); }

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

        @media (max-width: 1024px) {

            body {
                padding: 0;
                margin: 0;
                max-height: 405px;
                /*zoom: 0.88;*/
                /*transform: scale(0.9);
                transform-origin: top;*/
            }
            .modal {
                zoom: 0.8;
            }
            .modal-content {
                top: -3%;
            }
            
            .main-container {
                margin: 2px;
                max-height: 405px;
            }
            .container-fluid {
                padding: 0;
                max-height: 405px;
            }
            .flex-container {
                max-height: 405px;
            }
            #game {
                padding: 2px;
                max-height: 405px;
            }
            #tabs {

            }
            #tabs button .tab-desc {
                display: none !important;
            }
            #map-container {
                zoom: 0.8;
                max-width: 99%;
            }
            #inventory, #store {
                zoom: 0.9;
                max-height: 400px;
            }
            #map {
                margin-top: -13px;
            }
            #battle-view {
                zoom: 0.8;
            }
            #equipment {
                zoom: 0.75;
            }
            #log {
                display: none !important;
            }
        }

        @media (max-width: 467px) {
            .flex-container {
                display: block;
            }
            .modal-content {
                top: 29%;
            }
        }

    </style>

    <style>
        #slot-machine {
            text-align: center;
            margin-top: 40px;
            margin-bottom: 30px;
        }
        .slot-machine {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        #slot-result {
            margin-top: 20px;
        }
        .slot-window {
            width: 80px;
            height: 80px;
            overflow: hidden;
            border: 3px solid #aaa;
            border-radius: 10px;
            background: #111;
        }
        .slot-strip {
            display: flex;
            flex-direction: column;
            transform: translateY(0);
            transition: transform 1s ease-out;
        }
        .slot-strip div {
            font-size: 64px;
            width: 80px;
            height: 80px;
            display: flex;
            align-items: center;
            justify-content: center;
            line-height: 80px;
        }
        #slot-button:disabled {
            background-color: grey;
            cursor: default;
        }

        #tabs {
            margin-bottom: 10px;
        }
        #tabs button {
            padding: 5px 7px;
            margin-right: 0px;
            cursor: pointer;
            position: relative;
        }
        #tabs button.active {
            background: #0080ff;
            color: white;
            font-weight: bold;
        }
        #tabs button span.tab-desc {
            margin-bottom: 6px;
            display: inline-block;
            margin-left: 7px;
            font-size: 14px;
            font-weight: normal;
        }
        #tabs .tab-counter {
            position: absolute;
            background-color: #0098ff;
            width: 24px;
            border-radius: 50%;
            top: -7px;
            left: -4px;
            filter: drop-shadow(1px 1px 2px black);
        }
    </style>

    {ignore}
    <script>
        const slotItems = [
            { emoji: '🌟', name: 'Джекпот', reward2: 'Золоті монети' },
            { emoji: '🔮', name: 'Артефакт', reward2: 'Артефакт!' },
            { emoji: '📦', name: 'Сундук', reward2: 'Сундук!' },
            { emoji: '💰', name: 'Гроші', reward2: 'Два мішки золота!' },
            { emoji: '🍎', name: 'Їжа', reward2: 'Випадкова їжа!' },
            { emoji: '📈', name: 'Досвід', reward2: 'Трохи досвіду!' },
        ];

        const totalSymbols = 30;
        const symbolHeight = 80;

        function generateStripHTML(finalSymbol) {
            const strip = [];
            for (let i = 0; i < totalSymbols; i++) {
                const symbol = addEmoji(slotItems[Math.floor(Math.random() * slotItems.length)].emoji, '64px');
                strip.push(`<div>${symbol}</div>`);
            }
            strip.push(`<div>${finalSymbol}</div>`);
            return strip.join('');
        }

        function spinSlot() {
            // якщо немає ні золота ні квитків
            if (player.gold < gamblingPrice() && player.tickets < 1) {
                addLog(`🎰❌ У вас немає ${gamblingPrice()} 💰 золота!`, 'system');
                addPopupMessage(`${addEmoji('❌', '40px')}`, elements.slotButton);
                return;
            }

            if (player.tickets < 1) {
                player.gold -= gamblingPrice();
            } else {
                player.tickets--;
            }
            updateStats();

            const results = [];
            //const btn = document.getElementById('slot-button');
            document.getElementById('slot-result').innerHTML = `&nbsp;`;
            elements.slotButton.disabled = true;
            const scrollTimes = [
                2 + Math.random() * 2,
                2 + Math.random() * 2,
                2 + Math.random() * 2
            ];
            const summaryTimes = [
                scrollTimes[0] + 0.15,
                scrollTimes[1] + 0.3,
                scrollTimes[2] + 0.45,
            ];

            for (let i = 1; i <= 3; i++) {
                setTimeout(() => {
                const strip = document.getElementById(`slot${i}`);
                const finalSymbol = slotItems[Math.floor(Math.random() * slotItems.length)];
                results[i - 1] = finalSymbol;

                strip.innerHTML = generateStripHTML(addEmoji(finalSymbol.emoji, '64px'));

                strip.style.transition = 'none';
                strip.style.transform = `translateY(0px)`;
                void strip.offsetWidth;

                const targetIndex = totalSymbols;
                const offset = targetIndex * symbolHeight + 3;
                const scrollTime = scrollTimes[i - 1];

                strip.style.transition = `transform ${scrollTime}s ease-out`;
                strip.style.transform = `translateY(-${offset}px)`;

                // Після завершення останнього барабана
                if (i === 3) {
                    setTimeout(() => {
                        elements.slotButton.disabled = false;
                        checkWin(results);
                        }, Math.ceil(Math.max(...summaryTimes) * 1000));
                    }
                }, i * 150); // затримка між барабанами
            }
        }

        function checkWin(results) {
            const emojis = results.map(r => r.emoji);
            const names = results.map(r => r.name);
            const allSame = emojis.every(e => e === emojis[0]);
            
            let slotResult = document.getElementById('slot-result');

            let winResult = { emoji: '', count: 0};
            if (allSame) {
                slotResult.innerHTML = `🎉 Джекпот! Випало: ${addEmoji(emojis[0])} ${addEmoji(emojis[0])} ${addEmoji(emojis[0])}`;

                winResult = { emoji: emojis[0], count: 3};
            } else if (emojis[0] === emojis[1] || emojis[0] === emojis[2] || emojis[1] === emojis[2]) {

                const resultEmoji = (emojis[0] === emojis[1] || emojis[0] === emojis[2]) ? emojis[0] : emojis[1];
                const resultReward2 = slotItems.find(s => s.emoji == resultEmoji).reward2;

                winResult = { emoji: resultEmoji, count: 2};

                slotResult.innerHTML = `Пара: ${addEmoji(resultEmoji)} + ${addEmoji(resultEmoji)} Нагорода: ${resultReward2}`;
            } else {
                slotResult.innerHTML = `Співпадінь немає`;

                winResult = { emoji: emojis[0], count: 1};
            }

            doVictory(winResult);
        }

        // all victories logic
        // gamble(
        function doVictory(winResult) {
            if (winResult.count === 2) {
                if (winResult.emoji == `🌟`) {
                    const jackPot = Math.floor(gamblingPrice() * 2);

                    player.gold += jackPot;
                    addPopupMessage(`${addEmoji('🌟', '40px')}`, elements.slotButton);
                    addPopupMessage(`+${jackPot}${addEmojiPlayer('💰')}`, elements.playerEmoji, {color: '#ff0',fontSize: '20px'});
                    addLog(`🎰🌟🌟💰 Дві зірки! +${jackPot} 💰!`, 'slots', 'rgb(127 69 0)');
                } else if (winResult.emoji == `🔮`) {
                    spawnArtifacts(1);
                    addPopupMessage(`${addEmoji('🔮', '40px')}`, elements.slotButton);
                    addLog(`🎰🔮🔮 На карті з'явився артефакт!!!`, 'slots', 'rgb(127 69 0)');
                } else if (winResult.emoji == `📦`) {
                    spawnChest();
                    addPopupMessage(`${addEmoji('📦', '40px')}`, elements.slotButton);
                    addLog(`🎰📦📦 На карті з'явився сундук!!!`, 'slots', 'rgb(127 69 0)');
                } else if (winResult.emoji == `💰`) {
                    spawnGold(2);
                    addPopupMessage(`${addEmoji('💰', '40px')}`, elements.slotButton);
                    addLog(`🎰💰💰 На карті з'явились 2 мішки золота!!!`, 'slots', 'rgb(127 69 0)');
                } else if (winResult.emoji == `🍎`) {
                    spawnFruits(2);
                    addPopupMessage(`${addEmoji('🍎', '40px')}`, elements.slotButton);
                    addLog(`🎰🍎🍎 На карті з'явились їжа!!!`, 'slots', 'rgb(127 69 0)');
                } else if (winResult.emoji == `📈`) {
                    const randomXpParam = Math.random();
                    const maxXpOnLevel = 24 * player.level + (5 + player.level * 4);
                    const minXpOnLevel = Math.floor(maxXpOnLevel * 0.5);

                    const addingXp = rand(minXpOnLevel, maxXpOnLevel);
                    player.xp += addingXp;
                    
                    addPopupMessage(`${addEmoji('📈', '40px')}`, elements.slotButton);
                    addPopupMessage(`+${addingXp}${addEmojiPlayer('📈')}`, elements.playerEmoji, {color: '#ff0',fontSize: '20px'});
                    addLog(`🎰📈📈 Ви отримали ${addingXp} досвіду!!!`, 'slots', 'rgb(127 69 0)');
                }
            } else if (winResult.count === 3) {
                if (winResult.emoji == `🌟` || winResult.emoji == `💰`) {
                    const jackPot = Math.floor(gamblingPrice() * 5);
                    addPopupMessage(`${addEmoji('💰', '64px')}${addEmoji('💰', '64px')}${addEmoji('💰', '64px')}`, elements.slotButton, {
                        horizontalOffset: -76
                    });

                    player.gold += jackPot;

                    addPopupMessage(`+${jackPot}${addEmojiPlayer('💰')}`, elements.playerEmoji, {
                        color: '#ff0',
                        fontSize: '20px',
                    });

                    // + 5 мішків золота
                    spawnGold(5);
                    addLog(`🎰🎰🎰💰 Ви зірвали джекпот! ${jackPot} 💰!`, 'slots', 'rgb(127 69 0)');
                } else if (winResult.emoji == `🔮`) {
                    spawnArtifacts(3);
                    addPopupMessage(`${addEmoji('🔮', '64px')}${addEmoji('🔮', '64px')}${addEmoji('🔮', '64px')}`, elements.slotButton, {
                        horizontalOffset: -76
                    });
                    addLog(`🎰🔮🔮🔮 На карті з'явились 3 артефакти!!!`, 'slots', 'rgb(127 69 0)');
                } else if (winResult.emoji == `📦`) {
                    spawnChest(true);
                    spawnChest(true);
                    spawnChest(true);
                    addPopupMessage(`${addEmoji('📦👑', '64px')}${addEmoji('📦👑', '64px')}${addEmoji('📦👑', '64px')}`, elements.slotButton, {
                        horizontalOffset: -76
                    });
                    addLog(`🎰📦📦📦 На карті з'явились 3 золоті сундуки!!!`, 'slots', 'rgb(127 69 0)');
                } else if (winResult.emoji == `💰`) {
                    spawnGold(5);
                    addPopupMessage(`${addEmoji('💰', '64px')}${addEmoji('💰', '64px')}${addEmoji('💰', '64px')}`, elements.slotButton, {
                        horizontalOffset: -76
                    });
                    addLog(`🎰💰💰💰 На карті з'явились 5 мішків золота!!!`, 'slots', 'rgb(127 69 0)');
                } else if (winResult.emoji == `🍎`) {
                    spawnFruits(3);
                    spawnItem(potions[rand(0, potions.length - 1)]);
                    addPopupMessage(`${addEmoji('🍎', '64px')}${addEmoji('🍎', '64px')}${addEmoji('🍎', '64px')}`, elements.slotButton, {
                        horizontalOffset: -76
                    });
                    addLog(`🎰🍎🍎🍎 На карті з'явилось багато їжі та еліксир!!`, 'slots', 'rgb(127 69 0)');
                } else if (winResult.emoji == `📈`) {
                    const randomXpParam = Math.random();
                    const maxXpOnLevel = 24 * player.level + (5 + player.level * 4);
                    const minXpOnLevel = Math.floor(maxXpOnLevel * 0.5);

                    const addingXp = Math.floor(rand(minXpOnLevel, maxXpOnLevel) * 2.5);
                    player.xp += addingXp;
                    
                    addPopupMessage(`${addEmoji('📈', '64px')}${addEmoji('📈', '64px')}${addEmoji('📈', '64px')}`, elements.slotButton, {
                        horizontalOffset: -76
                    });
                    addPopupMessage(`+${addingXp}${addEmojiPlayer('📈')}`, elements.playerEmoji, {color: '#ff0',fontSize: '20px'});
                    addLog(`🎰📈📈📈 Ви отримали ${addingXp} досвіду!!!`, 'slots', 'rgb(127 69 0)');
                }
            } else {
                addLog(`🎰 Пощастить наступного разу!`, 'slots', 'rgb(127 69 0)');
            }
            checkLevelUp();
            updateStats();
            updateMap();
        }

    </script>
    {/ignore}
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
                            <span class="emoji-replace" data-emoji="⚔️" data-size="20px">АТК</span>: <span id="attack-display" >10</span>&nbsp;&nbsp;&nbsp;
                            <span class="emoji-replace" data-emoji="🛡️" data-size="20px">ЗАХ</span>: <span id="defense-display">5</span>&nbsp;&nbsp;&nbsp;
                            <span id="playerHeartEmoji" class="emoji-replace" data-emoji="❤️" data-size="20px">❤️</span>: <span id="max-health-display">100</span> <!--💜-->
                        </div>
                        <div class="health-bar player-health">
                            <div class="health-fill" id="player-health-bar"></div>
                        </div>
                        <div class="xp-bar player-xp">
                            <div class="xp-fill" id="player-xp-bar"></div>
                        </div>
                        <div id="stats" class="stats">
                            <span class="emoji-replace" data-emoji="👑" data-size="20px">👑</span>: <span id="level">1</span>&nbsp;&nbsp;&nbsp;
                            <span class="emoji-replace" data-emoji="💰" data-size="20px">💰</span>: <span id="gold">0</span>&nbsp;&nbsp;&nbsp;
                            <span class="emoji-replace" data-emoji="📈" data-size="20px">📈</span>: <span id="xp">0</span>/<span id="xpToNext">50</span>
                        </div>
                    </div>
                    <div id="vs"><span class="emoji-replace" data-emoji="⚔️" data-size="64px">⚔️</span></div>
                    <div id="enemy-view" style="display: block;">
                        <div id="enemy-emoji">👤</div>
                        <div id="enemy-name" style="font-size: 16px; display: none;">Ворог</div>
                        <div class="stats" id="enemy-stats">
                            <span class="emoji-replace" data-emoji="⚔️" data-size="20px">АТК</span>: ?&nbsp;&nbsp;&nbsp;
                            <span class="emoji-replace" data-emoji="🛡️" data-size="20px">ЗАХ</span>: ?&nbsp;&nbsp;&nbsp;
                            <span class="emoji-replace" data-emoji="❤️" data-size="20px">❤️</span>: 0
                        </div>
                        <div class="health-bar" id="enemy-health-bar-wrapper">
                            <div class="health-fill" id="enemy-health-bar"></div>
                        </div>
                    </div>
                </div>
                
                <div id="controls">
                    <button id="inventoryBtn" style="display: inline-block; min-width: 216px;">🎒 Інвентар <span id='inventoryFullness'>(Пусто)</span> [I]</button>
                    <button id="mapBtn" style="display: none; min-width: 216px;">🗺️ Карта [I]</button>
                    <button id="healBtn" style="display: none;">💊 Лікуватися (10 золота)</button>
                    <button id="gambleBtn" style="display: none;">🎰 Гемблінг (<span id="gamblePrice-old">50💰</span>) [G]</button>
                    <button id="storeBtn" style="display: none; min-width: 216px;">🏬 Крамниця [S]</button>
                    <button id="resurrectBtn" style="display: none;">💀 Відродитись [R]</button>
                </div>

                <div id="equipment">
                    <div>Зброя: <span id="weapon-slot" class="equipment-slot item-weapon">Пусто</span></div>
                    <div>Броня: <span id="armor-slot" class="equipment-slot item-armor">Пусто</span></div>
                    <div>Кільце: <span id="ring-slot" class="equipment-slot item-ring">Пусто</span></div>
                    <div>Амулет: <span id="amulet-slot" class="equipment-slot item-amulet">Пусто</span></div>
                    <div>Книга: <span id="book-slot" class="equipment-slot item-book">Пусто</span></div>
                    <div>Реліквія: <span id="relic-slot" class="equipment-slot item-relic">Пусто</span></div>
                </div>
            </div>

            <div class="game-column">
                <div id="tabs">
                    <button data-tab="levels">Рівні</button>
                    <button data-tab="map-block">Карта</button>
                    <button data-tab="inventory">Інвентар</button>
                    <button data-tab="store">Крамниця</button>
                    <button data-tab="slots">Гемблінг</button>
                </div>

                <div id="map-container">
                    <div id="levels" style="">
                        <button class="levels-selector" data-level="1">Рівень 1</button>
                    </div>
                    <div id="map-block">
                        <div id="map" style="display:none;"></div>
                    </div>
                    <div id="inventory" style="display:none;">
                        <div>🎒 Інвентар</div>
                        <button id="closeInventoryBtn">❌</button>
                        <div id="inventory-items"></div>
                    </div>
                    <div id="store" style="display:none;">
                        <div id="store-name" style="display:inline-block;">🏬 Крамниця</div>
                        <div id="button-store-wrapper">
                            <button id="updateStoreBtn">🔁 Оновити асортимент (<span id="updateStorePrice">25💰</span>)</button>
                        </div>
                        <button id="closeStoreBtn">❌</button>
                        <div id="store-items"></div>
                    </div>
                    <div id="slots" style="display:none;">
                        <div id="slot-machine">
                            <div class="slot-machine">
                              <div class="slot-window"><div class="slot-strip" id="slot1"></div></div>
                              <div class="slot-window"><div class="slot-strip" id="slot2"></div></div>
                              <div class="slot-window"><div class="slot-strip" id="slot3"></div></div>
                            </div>
                            <button id="slot-button" onclick="spinSlot()">Крутити (<span id="gamblePrice">25💰</span>) [G]!</button>
                            <div id="slot-result">&nbsp;</div>
                        </div>
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
            tickets: 0, // квитки для гемблінгу
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
            inStore: false, // чи відкрито меню крамниці?
            inLevelSelection: true, // в меню вибору рівня
            atStore: false, // чи гравець стоїть біля крамниці?
            clearedRooms: 0, // кількість зачищенних "кімнат"
            position: { x: 0, y: 0 },
            get attack() {
                let attack = this.baseAttack;
                if (this.equipment.weapon) attack += (this.equipment.weapon.attack || 0);
                if (this.equipment.armor) attack += (this.equipment.armor.attack || 0);
                if (this.equipment.ring) attack += (this.equipment.ring.attack || 0);
                if (this.equipment.amulet) attack += (this.equipment.amulet.attack || 0);
                if (this.equipment.book) attack += (this.equipment.book.attack || 0);
                if (this.equipment.relic) attack += (this.equipment.relic.attack || 0);
                return attack;
            },
            get defense() {
                let defense = this.baseDefense;
                if (this.equipment.armor) defense += (this.equipment.armor.defense || 0);
                if (this.equipment.weapon) defense += (this.equipment.weapon.defense || 0);
                if (this.equipment.ring) defense += (this.equipment.ring.defense || 0);
                if (this.equipment.amulet) defense += (this.equipment.amulet.defense || 0);
                if (this.equipment.book) defense += (this.equipment.book.defense || 0);
                if (this.equipment.relic) defense += (this.equipment.relic.defense || 0);
                return defense;
            },
            get maxHealth() {
                // один рівень дає +3 хп інший +2 хп
                let maxHealth = Math.round(this.bonusHealth + 20 + (this.level - 1) * 2.5);  // Зменшено приріст здоров'я за рівень
                if (this.equipment.weapon) maxHealth += (this.equipment.weapon.maxHealth || 0);
                if (this.equipment.armor) maxHealth += (this.equipment.armor.maxHealth || 0);
                if (this.equipment.ring) maxHealth += (this.equipment.ring.maxHealth || 0);
                if (this.equipment.amulet) maxHealth += (this.equipment.amulet.maxHealth || 0);
                if (this.equipment.book) maxHealth += (this.equipment.book.maxHealth || 0);
                if (this.equipment.relic) maxHealth += (this.equipment.relic.maxHealth || 0);
                // додаєм потужне мега-життя
                maxHealth += player.overpoweredHealth;

                return maxHealth;
            },
            // інфа з локації на якій знаходиться
            getCurrentCell() {
                if (gameMap[this.position.y] == undefined || gameMap[this.position.y][this.position.x] == undefined) return false;
                return gameMap[this.position.y][this.position.x];
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
        const equipmentEmojies = {
            'weapon': '⚔️',
            'armor': '🛡️',
            'ring': '💍',
            'amulet': '📿',
            'book': '📖',
            'relic': '🔮',
            'potion': '🧪',
        };
        const equipableTypes = ['weapon', 'armor', 'ring', 'amulet', 'book', 'relic'];

        const storeTypes = [
            // flea - блошиний ринок, нічого не продає, але все скупає, знаходиться на стартовій локації
            { name: 'Барахолка', type: 'flea', emoji: '🏬🗑️', emojiTrader: '🤝🗑️', chance: 25, isRefreshing: false, isSpawnable: false },
            // general - все по троху найпоширеніший
            { name: 'Крамниця', type: 'general', emoji: '🏬', emojiTrader: '🤝🏬', chance: 25, isRefreshing: true, isSpawnable: true },
            // armory - виключно зброя і броня
            { name: 'Зброярня', type: 'armory', emoji: '🏬⚔️', emojiTrader: '🤝⚔️', chance: 25, isRefreshing: true, isSpawnable: true },
            // jewelry - ювелірка: кільця і амулети
            { name: 'Ювелірна лавка', type: 'jewelry', emoji: '🏬💍', emojiTrader: '🤝💍', chance: 15, isRefreshing: true, isSpawnable: true },
            // library - бібліотека/книгарня
            { name: 'Книгарня', type: 'library', emoji: '🏬📖', emojiTrader: '🤝📖', chance: 15, isRefreshing: false, isSpawnable: true },
            // antiques - антикваріат - виключно артефакти
            { name: 'Антиквар', type: 'antiques', emoji: '🏬🔮', emojiTrader: '🤝🔮', chance: 15, isRefreshing: true, isSpawnable: true },
            // medic - лєчілка + еліксири (1-2 штукі) 
            //{ name: 'Шпиталь', type: 'medic', emoji: '🏬💖', chance: 0.15, isRefreshing: false },
            // містичний магаз з одним типом артефакту у різних варіаціях але неможливо оновити асортимент
            { name: 'Містична лавка', type: 'mystic', emoji: '🏬✨', emojiTrader: '🤝✨', chance: 1, isRefreshing: false, isSpawnable: true },
        ];
        let lastChosenStores = []; // зберігаємо type або name

        // предмети з крамниці
        // структура наступна:
        /*
            { ...storeType[0], id: uniqId, listOfGoods:[] }
        */
        let allStoresHub = [];

        function getStoreHubById(hubId) {
            hubIndex = allStoresHub.findIndex(h => h.id == hubId);
            if (hubIndex == -1) return false;
            else {
                return { index: hubIndex, ...allStoresHub.find(h => h.id == hubId)};
            }
        }

        // одна й та сам крамниця буде траплятись мінімум через 3 
        const storeHistoryLimit = 3;

        let currentStoreType = 'general';

        const extraStyleMainIcons = 'vertical-align: sub !important; margin-left: 4px; margin-bottom: 2px';

        const preparedStartLevel = [// 🌳 // 🌲
            ['🗻', '🗻', '🗻', '🗻', '🗻', '🗻', '🗻', '🗻', '🗻', '🗻', '🗻'],
            ['🗻', '🗻', '🗻', '🗻', '🌲', '🗻', '🌲', '🗻', '🗻', '🗻', '🗻'],
            ['🗻', '🗻', '🗻', '🗻', '🌳', '🏬🗑️', '🌳', '🗻', '🗻', '🗻', '🗻'],
            ['🗻', '🗻', '🗻', '🌳', ' ', ' ', ' ', '🌳', '🗻', '🗻', '🗻'],
            ['🗻', '🗻', '🌲', '🌳', ' ', ' ', ' ', '🌳', '🌲', '🗻', '🗻'],
            ['🗻', '🧙‍♂️', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '🚪'],
            ['🗻', '🗻', '🌲', '🌳', ' ', ' ', ' ', '🌳', '🌲', '🗻', '🗻'],
            ['🗻', '🗻', '🗻', '🌳', ' ', ' ', ' ', '🌳', '🗻', '🗻', '🗻'],
            ['🗻', '🗻', '🗻', '🗻', '🌳', '🌳', '🌳', '🗻', '🗻', '🗻', '🗻'],
            ['🗻', '🗻', '🗻', '🗻', '🌲', '🗻', '🌲', '🗻', '🗻', '🗻', '🗻'],
            ['🗻', '🗻', '🗻', '🗻', '🗻', '🗻', '🗻', '🗻', '🗻', '🗻', '🗻'],
        ];
        // бібліотека емоджі
        const emojiReplacer = [
                // базові
            { type: '❤️', image: 'health.png' },
            { type: '💖', image: 'sparkling-heart.png' },
            { type: '💜', image: 'purple-heart.png' },
            { type: '💰', image: 'money-sack.png' },
            { type: '⚔️', image: 'attack.png' },
            { type: '🤝', image: 'trade.png' }, // -
            { type: '🛡️', image: 'defense.png' },
            { type: '👑', image: 'crown.png' },
            { type: '📈', image: 'xp.png' },
            { type: '🌟', image: 'star.png' },
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
            { type: '💫', image: 'trap.png' },
            { type: '🚪', image: 'exit.png' },
            { type: '❌', image: 'cancel.png' },
                // перешкоди
            { type: '🗻', image: 'obs-mountain-2.png' },
            { type: '🌳', image: 'obs-tree-3.png' },
            { type: '🌲', image: 'obs-tree-4.png' },
                // крамниця 🏬
            { type: '🏬', image: 'store.png' },
            { type: '🎟️', image: 'ticket.png' },
            { type: '🗺️', image: 'map.png' },
            { type: '🎒', image: 'inventory.png' },
            { type: '🌐', image: 'levels.png' },
            { type: '🎰', image: 'slot-machine.png' },
                // торговці
            { type: '🤝🗑️', image: 'trader-flea.png' },
            //{ type: '🤝📜', image: 'trader-quest.png' }, // -
            { type: '🤝🏬', image: 'trader-general.png' },
            { type: '🤝⚔️', image: 'trader-armory.png' },
            { type: '🤝💍', image: 'trader-jewelry.png' },
            { type: '🤝📖', image: 'trader-library.png' },
            { type: '🤝🔮', image: 'trader-antiques.png' },
            { type: '🤝✨', image: 'trader-mystic.png' },

                // фрукти
            { type: '🍎', image: 'red-apple.png' },
            { type: '🍌', image: 'banana.png' },
            { type: '🍇', image: 'grapes.png' },
            { type: '🍕', image: 'pizza.png' },
            { type: '🥩', image: 'meat.png' },
                // weapon
            { type: '🏒', subtype: 1, image: 'weapon-staff.png' },
            { type: '🗡', subtype: 1, image: 'wooden-sword.png' },
            { type: '🔪', subtype: 1, image: 'weapon-dagger.png' },
            { type: '🏏', subtype: 3, image: 'weapon-club.png' },
            { type: '🪓', subtype: 4, image: 'weapon-axe.png' },
            { type: '🔱', subtype: 5, image: 'weapon-spear.png' },
            { type: '🗡️', subtype: 6, image: 'weapon-sword-old.png' },
            { type: '⛏️', subtype: 15, image: 'weapon-scythe.png' },
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
            { type: '🧥🪓', subtype: 12, image: 'armor-of-wood.png' },
            { type: '🧥', subtype: 2, image: 'leather-armor.png' },
            { type: '🧥✨', subtype: 2, image: 'leather-armor-2.png' },
            { type: '⛓️', subtype: 3, image: 'armor-chainmail.png' },
            { type: '⛓️✨', subtype: 3, image: 'armor-chainmail-2.png' },
            { type: '⛓️', subtype: 4, image: 'scale-armour.png' },
            { type: '🛡️🛡️', subtype: 5, image: 'armor-cuirass.png' },
            { type: '🛡️✨', subtype: 5, image: 'armor-cuirass-2.png' },
            { type: '🛡️🛡️', subtype: 6, image: 'plate-armor.png' },
            { type: '🛡️✨', subtype: 6, image: 'plate-armor-2.png' },
            { type: '🛡️👑', subtype: 7, image: 'armor-of-myth.png' },
            { type: '🛡️✨', subtype: 7, image: 'armor-of-myth-2.png' },
            { type: '🐉⛓️', subtype: 8, image: 'dragon-armor.png' },
            { type: '🛡️🌟', subtype: 9, image: 'legendary-armor.png' },
            { type: '🛡️❄️', subtype: 11, image: 'armor-crystal.png' },
            { type: '🛡️✨', subtype: 10, image: 'elven-armor.png' },
                // кільця
            { type: '💍', subtype: 11, image: 'wooden-ring.png' },
            { type: '💍', subtype: 12, image: 'wooden-ring-2.png' },
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
            { type: '📿🔮', subtype: 10, image: 'amulet-of-unity.png' },
                // книги 10
            { type: '📖', subtype: 1, image: 'book.png' },
            { type: '📖', subtype: 2, image: 'book-2.png' },
            { type: '📖', subtype: 3, image: 'book-3.png' },
            { type: '📖', subtype: 4, image: 'book-4.png' },
            { type: '📖', subtype: 5, image: 'book-5.png' },
            { type: '📖', subtype: 6, image: 'book-6.png' },
            { type: '📖', subtype: 7, image: 'book-7.png' },
            { type: '📖', subtype: 8, image: 'book-8.png' },
            { type: '📖', subtype: 9, image: 'book-9.png' },
            { type: '📖', subtype: 10, image: 'book-0.png' },
                // релікти
            { type: '🏆', subtype: 1, image: 'relic-01.png' },
            { type: '🏆', subtype: 2, image: 'relic-02.png' },
            { type: '🏆', subtype: 3, image: 'relic-03.png' },
            { type: '🏆', subtype: 4, image: 'relic-04.png' },
            { type: '🏆🐉', subtype: 5, image: 'relic-05.png' },
            { type: '🏆🌟', subtype: 6, image: 'relic-06.png' },
            { type: '👑🔥', subtype: 7, image: 'relic-07.png' },
            { type: '🔮', subtype: 8, image: 'relic-08.png' },
            { type: '👑☠️', subtype: 9, image: 'relic-skull.png' },
            { type: '🔮', subtype: 10, image: 'relic-sphere.png' },
            { type: '🐚', subtype: 11, image: 'relic-seashell.png' },
            { type: '📜', subtype: 12, image: 'relic-scroll.png' },
            { type: '🏆☠️', subtype: 13, image: 'relic-icon-skull.png' },
            { type: '🍭', subtype: 14, image: 'relic-branch.png' },
            { type: '🐝', subtype: 15, image: 'relic-fireflies.png' },
            // 

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
                // icons
            /*{ type: '🛡️', subtype: -1, image: 'armor-cuirass.png' },*/
            { type: '📖', subtype: -1, image: 'book-4.png' },
            { type: '📿', subtype: -1, image: 'amulet-0.png' },
            
            /*
            { type: '⚔️', subtype: -1, image: 'weapon-0.png' },
            { type: '🛡️', subtype: -1, image: 'armor-0.png' },
            { type: '💍', subtype: -1, image: 'ring-0.png' },
            { type: '📿', subtype: -1, image: 'amulet-0.png' },
            { type: '📖', subtype: -1, image: 'book-0.png' },
            { type: '🔮', subtype: -1, image: 'relic-0.png' },
            { type: '🧪', subtype: -1, image: 'potion-0.png' },
            */
        ];

        const booksCounter = 10;

        // перешкоди
        const obstacles = [
            { type: 'tree', emoji: '🌳', color: '#2a5a1a', name: 'Дерево' },
            { type: 'tree', emoji: '🌲', color: '#2a5a1a', name: 'Сосна' },
            { type: 'mountain', emoji: '🗻', color: '#aaaaaa', name: 'Гора' }
        ];

        // Ігрові квитки можна використати для гемблінгу, або зміни асортименту магазину
        const ticket = { name: 'Квиток', emoji: '🎟️', rarity: 1, value: 200, type: 'ticket' };

        let synonyms = [
            // зброя
            { name: "Посох",            aliases: ["Тростина", "Патериця"] },
            { name: "Дерев'яний меч",   aliases: ["Дубовий меч", "Тренер", "Грабовий меч", "Бокуто"] },
            { name: "Кинджал",          aliases: ["Ніж", "Стилет", "Лезо", "Малий меч", "Тихий клинок", "Дирк"] },
            { name: "Дубина",           aliases: ["Булава", "Палиця", "Дубець", "Дрючок"] },
            { name: "Сокира",           aliases: ["Топір", "Сокирка", "Рубало", "Колун", "Головоруб", "Сікач"] },
            { name: "Спис",             aliases: ["Піка", "Ратище", "Протазан", "Острога", "Еспонтон"] },
            { name: "Меч",              aliases: ["Клинок", "Шабля", "Довгий меч"] },
            { name: "Коса",             aliases: ["Жнець", "Різак"] },
            { name: "Кистінь",          aliases: ["Обушок", "Бойовий бич", "Ціп", "Гупілон"] },
            { name: "Бойовий молот",    aliases: ["Молот", "Кувалда", "Трощило", "Клевець", "Киянка"] },
            { name: "Лук",              aliases: ["Довгий лук", "Короткий лук", "Дальнобій"] },
            { name: "Арбалет",          aliases: ["Самостріл", "Болтер", "Міні-баліста", "Снайпер"] },
            { name: "Магічний меч",     aliases: ["Чар-клинок", "Зачарований", "Чар-сталь", "Сяйво"] },
            { name: "Катана",           aliases: ["Японський меч", "Вакідзаші", "Тачі", "Дайкатана"] },
            { name: "Вогняний меч",     aliases: ["Полум'я", "Палаючий меч", "Жар-лезо", "Меч вогню", "Іскра"] },
            { name: "Міфічний клинок",  aliases: ["Легендарний", "Фантом-лезо", "Міф-сталь", "Герой-меч", "Містик"] },

            // броня
            { name: "Плащ",             aliases: ["Накидка", "Легкий плащ"] },
            { name: "Деревна броня",    aliases: ["Кора", "Дубовий жилет"] },
            { name: "Шкіряний жилет",   aliases: ["Жилет", "Тканий жилет", "Дублет", "Гамбезон"] },
            { name: "Шкіряна броня",    aliases: ["Шкірянка", "Стара броня"] },
            { name: "Кольчуга",         aliases: ["Байдана", "Гауберк"] },
            { name: "Бектер",           aliases: ["Бахтерець", "Юшман"] },
            { name: "Луската броня",    aliases: ["Бригантина", "Луска"] },
            { name: "Кіраса",           aliases: ["Лорика", "Сталь", "Зерцало"] },
            { name: "Панцир",           aliases: ["Кована броня"] },
            { name: "Латна броня",      aliases: ["Лати", "Тяжка броня"] },
            { name: "Обладунки",        aliases: ["Важка броня"] },
            { name: "Міфічна броня",    aliases: ["Княжа броня"] },
            { name: "Елітна броня",     aliases: ["Елітні лати"] },
            { name: "Драконяча шкура",  aliases: ["Луска дракона", "Дракон"] },
            { name: "Легендарна броня", aliases: ["Легенда", "Епос"] },
            { name: "Кристальна броня", aliases: ["Кристал", "Магічна броня"] },
            { name: "Ельфійська броня", aliases: ["Сонячна броня", "Броня ночі"] },

            // релікти
            { name: "Мітка",            aliases: ["Прокляття", "Проклін"] },
            { name: "Сувій",            aliases: ["Звиток", "Згорток"] },
            { name: "Мушля",            aliases: ["Спрут", "Паразит"] },
            { name: "Гарний тютюн",     aliases: ["Кисет трав", "Старий капшук"] },
            { name: "Парость",          aliases: ["Гілля", "Пагін"] },
            { name: "Есенція",          aliases: ["Гуща", "Амальгама"] },
            { name: "Камінці безодні",  aliases: ["Нігредо", "Обсидіан"] },
            { name: "Кристал влади",    aliases: ["Цитринітас", "Смарагд"] },
            { name: "Чиста руна",       aliases: ["Альґіз", "Камінь захисту"] },
            { name: "Світляки",         aliases: ["Чарівні мухи", "Рій"] },
            { name: "Око дракона",      aliases: ["Око змія", "Окулус"] },
            { name: "Серце дракона",    aliases: ["Змієва душа", "Осердя люті"] },
            { name: "Корона вогню",     aliases: ["Діадема", "Полум'я влади"] },
            { name: "Череп ліча",       aliases: ["Відьмина голова", "Мара"] },
            { name: "Палантір",         aliases: ["Магічний шар", "Орб"] },
            
        ];

        let itemDescriptions = [
            // weapons
            { name: "Посох",            desc: "Ідеальний для магів і тих, хто просто забув меч вдома." },
            { name: "Дерев'яний меч",   desc: "Початкова зброя для тих, хто ще не забув, що сила — не лише в залізі." },
            { name: "Кинджал",          desc: "Легкий, швидкий, підступний і завжди неочікуванний." },
            { name: "Дубина",           desc: "Важка, пряма, без сентиментів. Говорить мовою ударів." },
            { name: "Сокира",           desc: "Дерево, м’ясо, броня — не розбирає, просто січе." },
            { name: "Спис",             desc: "Для соціально дистанційованих воїнів. Елегантно, без зайвих обіймів." },
            { name: "Меч",              desc: "Класика. Баланс сталі, честі й готовності до всього." },
            { name: "Коса",             desc: "Тонка межа між життям і землею." },
            { name: "Кистінь",          desc: "Ланцюг і гнів. Вивертає щити, вибиває зуби, залишає враження." },
            { name: "Бойовий молот",    desc: "Ідеальний інструмент для ремонту облич." },
            { name: "Лук",              desc: "Проблеми люблять дистанцію." },
            { name: "Арбалет",          desc: "Той самий лук, але лінивий. Натискай — і дивись, як хтось передумав жити." },
            { name: "Магічний меч",     desc: "Не кожен зможе розкрити його повністю — але кожен відчує, що тримає щось більше, ніж просто клинок." },
            { name: "Катана",           desc: "Її точність не терпить шуму — тільки чіткий рух і тиша після нього." },
            { name: "Вогняний меч",     desc: "Горить, як лють. Після нього не залишається нічого, крім попелу." },
            { name: "Міфічний клинок",  desc: "Кажуть, що ним колись розсікли саму реальність." },

            // броня
            { name: "Плащ",             desc: "Легкий і загадковий, приховує тебе від чужих очей краще, ніж від холодної зброї." },
            { name: "Деревна броня",    desc: "Броня виготовлена з кори магічного дерева. Мінімальний захист за невеликі гроші." },
            { name: "Шкіряний жилет",   desc: "Гнучкий і легкий, хороший захист від слабких ударів." },
            { name: "Шкіряна броня",    desc: "Просочена воском і майстерністю, тримає стріли подалі від твого серця." },
            { name: "Кольчуга",         desc: "Дзвінка та гнучка, ідеальна для тих, хто цінує рухливість у бою." },
            { name: "Бектер",           desc: "Сталеві пластинки поверх кольчуги, поєднують гнучкість із міцністю." },
            { name: "Луската броня",    desc: "Ця броня імітує природний захист рептилій, дозволяючи воїну рухатися плавно, немов змія." },
            { name: "Кіраса",           desc: "Нагрудник із міцної сталі, здатний відбивати навіть сильні удари." },
            { name: "Панцир",           desc: "Суцільний металевий захист, який змушує ворожі мечі втрачати гостроту." },
            { name: "Латна броня",      desc: "Латні пластини покривають кожен дюйм тіла, залишаючи ворогам лише надію на втечу." },
            { name: "Обладунки",        desc: "Комплект повного захисту, створений, щоб перетворити тебе на живу фортецю." },
            { name: "Міфічна броня",    desc: "Просякнута магією древніх, захищає не лише тіло, а й душу." },
            { name: "Елітна броня",     desc: "Престижна й міцна, належить лише найкращим воїнам королівства." },
            { name: "Драконяча шкура",  desc: "Легендарна шкіра дракона, що не знає рівних у стійкості до вогню і сталі." },
            { name: "Легендарна броня", desc: "Оповита легендами, цей обладунок пережив більше битв, ніж пам'ятає історія." },
            { name: "Кристальна броня", desc: "Міцніша за сталь і красива як коштовність, ця броня сяє навіть у пітьмі." },
            { name: "Ельфійська броня", desc: "Витончена й легка, створена руками ельфійських майстрів." },

            // кільця
            { name: "Дерев'яне кільце", desc: "Простий магічний перстень, що єднає тебе з природою." },
            { name: "Мідне кільце",     desc: "Виковане з магічної міді, що проводить енергію в кожен твій удар." },
            { name: "Срібне кільце",    desc: "Срібло оберігає — як від мечів, так і від злих духів." },
            { name: "Золоте кільце",    desc: "Блиск здоров'я і трішечки розкоші в кожному бою." },
            { name: "Кільце сили",      desc: "Для тих, хто хоче вирішити все одним ударом." },
            { name: "Кільце захисту",   desc: "Магічний бар’єр, стиснутий у тонке кільце." },
            { name: "Перстень волі",    desc: "Для тих, у кого тверда не лише голова, а й наміри." },
            { name: "Кільце воїна",     desc: "Залізна воля та блискавичний удар. Справжній товариш в бою." },
            { name: "Кільце мага",      desc: "Створене з думок, шепотів і старих заклять." },
            { name: "Кільце титана",    desc: "Носити це кільце – як мати дозвіл на руйнування світу." },
            { name: "Кільце дракона",   desc: "Реве, коли ти б'єш ворогів." },
            { name: "Кільце безсмертя", desc: "Останнє кільце, яке ти коли-небудь вдягнеш. І перше, про яке складуть баладу." },

            // амулети
            { name: "Оберіг",           desc: "Простий амулет, освячений друїдами." },
            { name: "Амулет здоров'я",  desc: "Насичений життєвою енергією — кожен його вузол б’ється, як серце." },
            { name: "Амулет воїна",     desc: "Амулет для тих, хто йде на зустріч мечу. Збільшує міць і витривалість у бою." },
            { name: "Амулет мудрості",  desc: "Руни на ньому шепочуть про захист і розважливість." },
            { name: "Амулет берсерка",  desc: "Палає жагою до битви. Дає силу, але позбавляє обачності." },
            { name: "Амулет захисника", desc: "Символ непохитної стійкості. Жертвує атакою заради абсолютної оборони." },
            { name: "Амулет балансу",   desc: "Інь і Ян на нитці — гармонія між життям та смертю." },
            { name: "Амулет безсмертя", desc: "Містить іскорку вічного вогню. Допоки він світиться — ти стоїш." },
            { name: "Амулет фенікса",   desc: "У серці цього амулета — полум’я переродження. Життя, яке не згасає." },
            { name: "Амулет єднання",   desc: "Легендарний артефакт, що об'єднує силу, мудрість і життя в єдине ціле." },

            // книги
            { name: "Записник",         desc: "Порожні сторінки чекають на твої думки, і, можливо, парочку заклять..." },
            { name: "Посібник",         desc: "Короткий виклад технік нападу. Просто, чітко, з ілюстраціями для новачків." },
            { name: "Підручник",        desc: "Захисні прийоми, основи магічного бар'єру та поради, як не померти — в одній книзі." },
            { name: "Довідник",         desc: "Містить купу корисної інформації — і трохи життєвої сили між рядків." },
            { name: "Лексис",           desc: "Баланс теорії та практики. Читаєш — б'єш точніше, тримаєшся довше." },
            { name: "Доктрина",         desc: "Священний текст для наступу. Тут кожне слово — мов наказ до атаки." },
            { name: "Монографія",       desc: "Глибоке дослідження захисту. Розкриє секрети стійкості навіть найтоншої броні." },
            { name: "Кодекс",           desc: "Суворий трактат, що формує справжнього бійця — сильного, стійкого, незламного." },
            { name: "Звід правил",      desc: "Тут описано, як бити сильно, правильно й ефектно. І не отримати у відповідь." },
            { name: "Гримуар",          desc: "Сторінки шепочуть закляття. Не слухай вголос — або слухай, якщо хоробрий." },
            { name: "Фоліант",          desc: "Справжній артефакт серед книг. Наділяє знанням, силою й витривалістю — усе в одному томі." },
            { name: "Книга пророцтв",   desc: "Її сторінки пишуться самі. Вони знають майбутнє, а інколи — і те, що краще не знати." },

            // реліквії
            { name: "Мітка",            desc: "Проклята річ, яка інколи приносить користь. Вона тебе вже запам’ятала." },
            { name: "Сувій",            desc: "Порожній артефакт. Чекає, щоб його наповнили змістом." },
            { name: "Мушля",            desc: "Якась мотрошна сила живе всередині неї." },
            { name: "Гарний тютюн",     desc: "...Якщо трапиться відьма чи диявол у людській подобі." },
            { name: "Парость",          desc: "Скручене гілля наповнене відьомскими чарами." },
            { name: "Есенція",          desc: "Усередині потрісканої глиняної кулі пульсує первісна енергія. Вона ричить і прагне вирватись — але закляття тримають її всередині." },
            { name: "Камінці безодні",  desc: "Темні, мов сама ніч, але дають непохитну витривалість. Тримати зачиненими." },
            { name: "Кристал влади",    desc: "Пульсує, мов серце бога. У кожному з його граней — сила удару, що змінює хід бою." },
            { name: "Чиста руна",       desc: "Ідеальна форма захисту, викарбувана в камені. Тиша, твердість, спокій — усе всередині." },
            { name: "Око дракона",      desc: "Гарячий погляд з іншого боку часу. Дивишся — і бачиш смерть заклятого ворога." },
            { name: "Світляки",         desc: "Живі вогники на варті. Дають життя, силу й настрій для вечірніх боїв." },
            { name: "Корона вогню",     desc: "Царство полум’я на твоїй голові. Вороги мають відчути її славу." },
            { name: "Череп ліча",       desc: "Дивиться сяючими очницями в твою душу. Віддає силу... але зберігає частинку тебе." },
            { name: "Серце дракона",    desc: "Серце великого дракона, вкрите чарами. Воно ніколи не зупиниться." },
            { name: "Палантір",         desc: "Всеосяжне око, що бачить більше, ніж тобі хотілося б." },

            // еліксири
            { name: "Еліксир сили",     desc: "Смарагдова рідина в трикутному флаконі. Вона чекає, коли знову потече в жилах і розбудить гнів." },
            { name: "Еліксир захисту",  desc: "Всередині — холод криги та мудрість каменю." },
            { name: "Еліксир життя",    desc: "Цей еліксир не лікує — він переконує смерть зачекати ще трохи." },

        ];


        // Оновлена база даних зброї з параметрами критичної шкоди 
        let weapons = [
            { name: "Посох", emoji: "🏒",          subtype: 1,            critChance: 0.1, rarity: 1, value: 5, type: "weapon" },
            { name: "Дерев'яний меч", emoji: "🗡",  subtype: 1, attack: 1, critChance: 0.03, rarity: 1, value: 5, type: "weapon" },
            { name: "Кинджал", emoji: "🔪",         subtype: 2, attack: 2, critChance: 0.15, rarity: 2, value: 25, type: "weapon" },
            { name: "Дубина", emoji: "🏏",          subtype: 3, attack: 3, critChance: 0.08, rarity: 2, value: 45, type: "weapon" },
            { name: "Сокира", emoji: "🪓",          subtype: 4, attack: 4, critChance: 0.1, rarity: 3, value: 85, type: "weapon" },
            { name: "Спис", emoji: "🔱",            subtype: 5, attack: 5, critChance: 0.1, rarity: 3, value: 135, type: "weapon" },
            { name: "Коса", emoji: "⛏️",            subtype: 15, attack: 7, defense: -2, critChance: 0.15, rarity: 3, value: 135, type: "weapon" },
            { name: "Меч", emoji: "🗡️",             subtype: 6, attack: 6, critChance: 0.12, rarity: 4, value: 220, type: "weapon" },
            { name: "Кистінь", emoji: "🏏",         subtype: 7, attack: 7, critChance: 0.1, rarity: 4, value: 310, type: "weapon" },
            { name: "Бойовий молот", emoji: "🔨",   subtype: 8, attack: 8, critChance: 0.07, rarity: 4, value: 420, type: "weapon" },
            { name: "Лук", emoji: "🏹",             subtype: 9, attack: 6, critChance: 0.2, rarity: 5, value: 260, type: "weapon" },
            { name: "Арбалет", emoji: "🎯",         subtype: 10, attack: 8, critChance: 0.25, rarity: 5, value: 555, type: "weapon" },
            { name: "Магічний меч", emoji: "🗡️",    subtype: 14, attack: 7, critChance: 0.3, rarity: 6, value: 440, type: "weapon" },
            { name: "Катана", emoji: "🗡",          subtype: 11, attack: 9, critChance: 0.15, rarity: 6, value: 645, type: "weapon" },
            { name: "Вогняний меч", emoji: "🗡🔥",  subtype: 12, attack: 12, critChance: 0.15, rarity: 7, value: 1375, type: "weapon" },
            { name: "Міфічний клинок", emoji: "🗡✨", subtype: 13, attack: 15, critChance: 0.2, rarity: 7, value: 2650, type: "weapon" }
        ];

        // Розширена база даних броні
        let armors = [
            { name: "Плащ", emoji: "🥼",            subtype: 1,                        rarity: 1, value: 5, type: "armor" },
            { name: "Деревна броня", emoji: "🧥🪓", subtype: 1, defense: 1,            rarity: 1, value: 5, type: "armor" },
            { name: "Шкіряний жилет", emoji: "🧥",   subtype: 2, defense: 2,            rarity: 2, value: 10, type: "armor" },
            { name: "Шкіряна броня", emoji: "🧥✨", subtype: 1, defense: 2, maxHealth: 5, rarity: 2, value: 25, type: "armor" },
            { name: "Кольчуга", emoji: "⛓️",        subtype: 3, defense: 3,             rarity: 3, value: 25, type: "armor" },
            { name: "Бектер", emoji: "⛓️✨",        subtype: 3, defense: 3, maxHealth: 5, rarity: 3, value: 50, type: "armor" },
            { name: "Луската броня", emoji: "⛓️",   subtype: 4, defense: 4,             rarity: 4, value: 50, type: "armor" },
            { name: "Кіраса", emoji: "🛡️🛡️",        subtype: 5, defense: 5,             rarity: 4, value: 100, type: "armor" },
            { name: "Панцир", emoji: "🛡️✨",        subtype: 5, defense: 5, maxHealth: 10, rarity: 4, value: 200, type: "armor" },
            { name: "Латна броня", emoji: "🛡️🛡️",   subtype: 6, defense: 6,             rarity: 4, value: 200, type: "armor" },
            { name: "Обладунки", emoji: "🛡️✨",     subtype: 6, defense: 6, maxHealth: 10, rarity: 5, value: 350, type: "armor" },
            { name: "Міфічна броня", emoji: "🛡️👑", subtype: 7, defense: 7,             rarity: 5, value: 350, type: "armor" },
            { name: "Елітна броня", emoji: "🛡️✨",  subtype: 7, defense: 7, maxHealth: 10, rarity: 5, value: 600, type: "armor" },
            { name: "Драконяча шкура", emoji: "🐉⛓️", subtype: 8, defense: 8,           rarity: 6, value: 700, type: "armor" },
            { name: "Легендарна броня", emoji: "🛡️🌟", subtype: 9, defense: 10,         rarity: 6, value: 1000, type: "armor" },
            { name: "Кристальна броня", emoji: "🛡️❄️", subtype: 11, attack: -2, defense: 14, rarity: 7, value: 1000, type: "armor" },
            { name: "Ельфійська броня", emoji: "🛡️✨", subtype: 10, defense: 12,        rarity: 7, value: 2000, type: "armor" }
        ];

        // Розширена база даних артефактів
        let artifacts = [
            // Кільця
            { name: "Дерев'яне кільце", emoji: "💍", subtype: 11, maxHealth: 5, rarity: 1, value: 5, type: "ring" },
            { name: "Мідне кільце", emoji: "💍",    subtype: 1, attack: 1, rarity: 2, value: 5, type: "ring" },
            { name: "Срібне кільце", emoji: "💍",   subtype: 2, defense: 1, rarity: 2, value: 5, type: "ring" },
            { name: "Золоте кільце", emoji: "💍",   subtype: 10, maxHealth: 10, rarity: 2, value: 20, type: "ring" },
            { name: "Кільце сили", emoji: "💍",     subtype: 3, attack: 2, rarity: 3, value: 20, type: "ring" },
            { name: "Кільце захисту", emoji: "💍",  subtype: 4, defense: 2, rarity: 3, value: 40, type: "ring" },
            { name: "Перстень волі", emoji: "💍",   subtype: 12, attack: 1, defense: 1, maxHealth: 5, rarity: 3, value: 40, type: "ring" },
            { name: "Кільце воїна", emoji: "💍",    subtype: 5, attack: 3, defense: 1, rarity: 4, value: 100, type: "ring" },
            { name: "Кільце мага", emoji: "💍",     subtype: 6, attack: 1, defense: 3, rarity: 4, value: 100, type: "ring" },
            { name: "Кільце титана", emoji: "💍🌟", subtype: 7, attack: 4, defense: 4, rarity: 5, value: 300, type: "ring" },
            { name: "Кільце дракона", emoji: "💍🐉", subtype: 8, attack: 5, defense: 3, rarity: 6, value: 300, type: "ring" },
            { name: "Кільце безсмертя", emoji: "💍✨", subtype: 9, attack: 3, defense: 5, maxHealth: 10, rarity: 7, value: 800, type: "ring" },
            
            // Амулети
            { name: "Оберіг", emoji: "📿",              subtype: 1, maxHealth: 5, rarity: 1, value: 10, type: "amulet" },
            { name: "Амулет здоров'я", emoji: "📿",     subtype: 2, maxHealth: 10, rarity: 2, value: 30, type: "amulet" },
            { name: "Амулет воїна", emoji: "📿",        subtype: 3, attack: 2, maxHealth: 5, rarity: 3, value: 50, type: "amulet" },
            { name: "Амулет мудрості", emoji: "📿",     subtype: 4, defense: 2, maxHealth: 5, rarity: 3, value: 50, type: "amulet" },
            { name: "Амулет берсерка", emoji: "📿",     subtype: 5, attack: 4, defense: -1, rarity: 4, value: 100, type: "amulet" },
            { name: "Амулет захисника", emoji: "📿",    subtype: 6, defense: 4, attack: -1, rarity: 4, value: 100, type: "amulet" },
            { name: "Амулет балансу", emoji: "📿",      subtype: 7, attack: 2, defense: 2, maxHealth: 10, rarity: 5, value: 250, type: "amulet" },
            { name: "Амулет безсмертя", emoji: "📿🌟",  subtype: 8, maxHealth: 40, rarity: 6, value: 500, type: "amulet" },
            { name: "Амулет фенікса", emoji: "📿🔥",    subtype: 9, maxHealth: 30, attack: 3, rarity: 6, value: 1000, type: "amulet" },
            { name: "Амулет єднання", emoji: "📿🔮",    subtype: 10, maxHealth: 25, defense: 3, attack: 3, rarity: 7, value: 2200, type: "amulet" },
            
            // Книги
            { name: "Записник", emoji: "📖",            subtype: 7,            rarity: 1, value: 2, type: "book" },
            { name: "Посібник", emoji: "📖",            subtype: 3, attack: 1, rarity: 2, value: 5, type: "book" },
            { name: "Підручник", emoji: "📖",           subtype: 3, defense: 1, rarity: 2, value: 5, type: "book" },
            { name: "Довідник", emoji: "📖",            subtype: 2, maxHealth: 5, rarity: 1, value: 5, type: "book" },
            { name: "Лексис", emoji: "📖",              subtype: 4, attack: 1, defense: 1, rarity: 3, value: 10, type: "book" },
            { name: "Доктрина", emoji: "📖",            subtype: 3, attack: 3, rarity: 3, value: 100, type: "book" },
            { name: "Монографія", emoji: "📖",          subtype: 4, defense: 3, rarity: 3, value: 100, type: "book" },
            { name: "Кодекс", emoji: "📖",              subtype: 5, attack: 2, defense: 2, rarity: 4, value: 150, type: "book" },
            { name: "Звід правил", emoji: "📖",         subtype: 1,  attack: 5, defense: 1, rarity: 4, value: 500, type: "book" },
            { name: "Гримуар", emoji: "📖",             subtype: 3, defense: 5, attack: 1, rarity: 5, value: 500, type: "book" },
            { name: "Фоліант", emoji: "📖",             subtype: 2, attack: 5, defense: 5, maxHealth: 15, rarity: 6, value: 1000, type: "book" },
            { name: "Книга пророцтв", emoji: "📖",      subtype: 1, attack: 7, defense: 7, maxHealth: 20, rarity: 7, value: 2000, type: "book" },
            
            // Реліквії
            // черепок єдиний виключно негативний релікт -2хп
            { name: "Мітка", emoji: "🏆☠️",      subtype: 13,    maxHealth: -2,                           rarity: 1, value: 1, type: "relic" },
            // сувій це порожній релікт
            { name: "Сувій", emoji: "📜",          subtype: 12,                                           rarity: 1, value: 2, type: "relic" },
            { name: "Мушля", emoji: "🐚",           subtype: 11, maxHealth: 10,  attack: 1,   defense: -1, rarity: 2, value: 100, type: "relic" },
            { name: "Гарний тютюн", emoji: "🏆",    subtype: 1,  maxHealth: 10,  attack: -1,  defense: 1, rarity: 2, value: 30, type: "relic" },
            { name: "Парость", emoji: "🍭",        subtype: 14,  maxHealth: 5,   attack: 1,   defense: 1, rarity: 3, value: 100, type: "relic" },
            { name: "Есенція", emoji: "🔮",        subtype: 10,  maxHealth: -5,  attack: 2,   defense: 2, rarity: 3, value: 100, type: "relic" },
            { name: "Камінці безодні", emoji: "🏆", subtype: 2,  maxHealth: 20,                            rarity: 4, value: 100, type: "relic" },
            { name: "Кристал влади", emoji: "🏆",   subtype: 3,                  attack: 5,                rarity: 4, value: 250, type: "relic" },
            { name: "Чиста руна", emoji: "🏆",      subtype: 4,                               defense: 5,  rarity: 4, value: 350, type: "relic" },
            { name: "Око дракона", emoji: "🏆🐉",   subtype: 5,                 attack: 7,   defense: 3,   rarity: 5, value: 1000, type: "relic" },
            { name: "Світляки", emoji: "🐝",        subtype: 15, maxHealth: 10,  attack: 4,   defense: 4,   rarity: 5, value: 1000, type: "relic" },
            { name: "Корона вогню", emoji: "👑🔥",  subtype: 7, maxHealth: 25,  attack: 5,   defense: 5,   rarity: 6, value: 2200, type: "relic" },
            { name: "Череп ліча", emoji: "👑☠️",   subtype: 9,  maxHealth: 15,  attack: 7,   defense: 3,   rarity: 6, value: 2200, type: "relic" },
            { name: "Серце дракона", emoji: "🏆🌟", subtype: 6, maxHealth: 30,  attack: 8,   defense: 8,   rarity: 7, value: 1500, type: "relic" },
            { name: "Палантір", emoji: "🔮",        subtype: 8, maxHealth: 40,  attack: 10,   defense: 10,  rarity: 7, value: 3500, type: "relic" }
        ];
        
        // Додаємо еліксири до бази даних предметів
        const potions = [
            { name: "Еліксир сили", emoji: "🧪", subtype: 1, type: "potion_attack", emojiType: "⚔️", description: "⚔️+1", effect: "attack", value: 100, bonus: 1, rarity: 2, canSell: false, color: '#0f0' },
            { name: "Еліксир захисту", emoji: "🧪", subtype: 2, type: "potion_defense", emojiType: "🛡️", description: "🛡️+1", effect: "defense", value: 100, bonus: 1, rarity: 2, canSell: false, color: '#00ceff' },
            { name: "Еліксир життя", emoji: "🧪", subtype: 3, type: "potion_health", emojiType: "💖", description: "💖+5", effect: "maxHealth", value: 100, bonus: 5, rarity: 2, canSell: false, color: 'red' }
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


        const bookNameParts = {
            part1: [
                "Saga de", "Clavicula", "Alchemia", "De Arte", "De Cursu", "Nox", "Fur", "Sol", "Dea", 
                "Rex", "Os", "Mos", "Vit", "Dom", "Mag", "Sag", "Lum", "Cor", "Spes", "Mors", "Aqua",
                "Cael", "Silv", "Temp", "Luna", "Mala", "Noxa", "Vera", "Alma", "Fata", "Tela", "Nekra",
                "Mortis", "Malum", "Una", "Daemon", "Atra", "Letum", "Verus", "Soma", "Era", "Era de", "O",
                // zodiac
                "Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpius", "Sagittarius", "Capricornus", "Aquarius", "Pisces",
                // saga
                "Saga de", "Saga de", "Saga de", "Saga de", "Saga de", "Saga de", "Saga de", "Saga de", 
                "Saga", "Saga", "Saga", "Saga", "Saga", "Saga", "Sag", "Saga", 
                "Ars", "Via", "Lex", "Ferrum", "Virtus", "Pugna", "Bellum", "Gladius", "Disciplina",
                "Animus", "Militia", "Honos", "Sanguis", "Corpus", "Vox", "Fatum", "Umbra", "Clamor",
                "Tempus", "Vigilantia", "Ignis", "Scutum", "Hostis", "Dominatio", "Victoria", "Praeceptum",
                "Potentia", "Mysteria", "Vis", "Incantatio", "Maleficium", "Elementum", "Sigillum",
                "Voluntas", "Lux", "Tenebrae", "Spiritus", "Flamma", "Ordo", "Somnium", "Numen",
                "Dominium", "Astrum", "Forma", "Aeon", "Symbolum", "Praedictio", "Manus", "Herba",
                "Sanctio", "Vita", "Remedium", "Lacrima", "Aura", "Flos", "Balsamum", "Sanatio", "Radix",
                "Pax", "Respiro", "Metus", "Memoria", "Custodia", "Somnus", "Lamina", "Solis", "Noctis",
                "Venenum", "Vocatio", "Aqua", "Caelum", "Terra", "Aether", "Mens", "Praesidium",
                "Oraculum", "Cinis", "Tempo", "Tenebra", "Silva", "Crux", "Fluctus", "Ave", "Dux",
                "Instantus", "Umbrae", "Vigil", "Somnia", "Noctua", "Oscura", "Aegis", "Amonita",
                "Cordis", "Mycena", "Fungus", "Myxa", "Folium", "Spora", "Boletus", "Psilocybe",
                "Russula", "Inocybe", "Marasmius", "Lentinula", "Lactarius", "Mycena", "Cedrus", "Salix",
                "Betula", "Ulmus", "Fragaria",
                "Nekro-", "Virto-", "Ferro-", "Corpo-", "Auro-", "Myco-", "Umbro-", "Pyro-", "Cryo-", "Xeno-", "Draco-", "Cosmo-", "Chao-", "Astra-",
            ],
            part2: [
                "Invictus", "Caelestis", "Internus", "Perpetuus", "Obscurus", "Honesta", "Solitaria",
                "Vetus", "Ultima", "Occultus", "Sacra", "Viva", "Fidelis", "Mortalis", "Cantans",
                "Silens", "Damnata", "Aeterna", "Cruenta", "Nobilis", "Ferrea", "Ardens", "Severa",
                "Implacabilis", "Victoriosa", "Morte", "Arcana", "Antiqua", "Magna", "Divina",
                "Perdita", "Profunda", "Inferna", "Ignota", "Eterna", "Primordius", "Silentia",
                "Interdicta", "Volatilis", "Astralis", "Incensa", "Mystica", "Maligna", "Invocata",
                "Velata", "Runica", "Sanctus", "Vitalis", "Pacifica", "Benedicta", "Clara", "Salvifica",
                "Serena", "Gravis", "Luminosa", "Naturalis", "Vivifica", "Medicinalis", "Florens",
                "Sincera", "Alba", "Lapis", "Sapida", "Dulcis", "Erratica", "Fracta", "Purificata",
                "Profanata", "Nemorosa", "Fulgida", "Vasta", "Invisibilis", "Fortunata", "Nocturna",
                "Gelida", "Cauta", "Cinerosa", "Ignita", "Spiritualis", "Tranquilla", "Periculosa",
                "Defensiva", "Demonia", "Satanae", "Irae", "Levitas", "Elixiria", "Obscura", "Bellis",
                "Ferro", "Occulta", "Vulnera", "Gloria", "Umbrarum", "Scripta", "Lunaris", "Ardentis", "Defensio",
                "Clypei", "Nova", "Muscaria", "Lucida", "Toxica", "Sylvarum", "Nigra", "Letalis",
                "Oreades", "Comatus", "Cubensis", "Robur", "Sativa", "Excelsior", "Communis", "Domestica",
                "Tremula", "Baccata", "Nervosa", "Mas", "Rubrum", "Vulgaris", "Myrtillus", "Sinensis",
                "Sorbi", "Nigrum", "Purpurea", "Satanas", "Formosa", "Conica", "Caninus", "Ruber",
                "Edulis", "Ovinus", "Aurantia", "Nivalis", "Proxima", "Fissilis", "Adusta", "Regius",
                "Corium", "Gigantea", "Chlora", "Archeri", "Borealis", "Maxima", "Minima", "Tenera",
                // numbers are special
                "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII",
            ]
        };

        const enemyTypes = [
            // Звичайні монстри
            { type: 'Гоблін', emoji: '👺', color: '#5f5', abilities: [] },
            { type: 'Скелет', emoji: '💀💀', color: '#fff', abilities: ['undead', 'disease'] },
            { type: 'Вовк', emoji: '🐕', color: '#aaa', abilities: ['fast', 'predator'] },
            { type: 'Павук', emoji: '🕷️', color: '#8b4513', abilities: ['poison'] },
            { type: 'Щур', emoji: '🐀', color: '#808080', abilities: ['disease', 'hungry'] },
            { type: 'Зомбі', emoji: '🧟', color: '#5a5', abilities: ['undead', 'tough', 'disease'] },
            { type: 'Привид', emoji: '👻', color: '#aaf', abilities: ['ghost', 'magic_resist'] },
            { type: 'Гарпія', emoji: '🦅', color: '#add8e6', abilities: ['flying', 'fast'] },
            { type: 'Ящіролюд', emoji: '🦎', color: '#ff6347', abilities: ['trap_master'] },
            
            // Елітні монстри
            { type: 'Орк-воїн', emoji: '👹', color: '#f55', abilities: ['strong', 'tough', 'hungry'], elite: true },
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

        // popup повідомлення
        let popupMessages = [];
        let popupSendingStatus = false;

        // Карта гри
        const mapSize = 11;
        let gameMap = [];
        let enemies = [];
        let visitedCells = new Set();
        let terraCognita = new Set();

        // Рівні гри які гравець вже пройшов
        let levelsCompleted = [];
        /**
         * Тепер головний параметр від якого залежить спав всього у грі
         * Встановлюється виключно через initMap
         */
        let currentMapLevel = 1;

        const sellCoefficient = 0.5;
        const buyCoefficient = 2.0;
        // шанс знайти квиток замість артефакту
        const ticketSpawnChance = 0.12;

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
            slotButton: document.getElementById('slot-button'),
            gamblePrice: document.getElementById('gamblePrice'),
            resurrectBtn: document.getElementById('resurrectBtn'),
            inventoryBtn: document.getElementById('inventoryBtn'),
            closeInventoryBtn: document.getElementById('closeInventoryBtn'),
            storeBtn: document.getElementById('storeBtn'),
            closeStoreBtn: document.getElementById('closeStoreBtn'),
            mapBtn: document.getElementById('mapBtn'),
            playerHealthBar: document.getElementById('player-health-bar'),
            playerXpBar: document.getElementById('player-xp-bar'),
            playerView: document.getElementById('player-view'),
            playerEmoji: document.getElementById('player-emoji'),
            playerHeartEmoji: document.getElementById('playerHeartEmoji'),
            enemyHealthBar: document.getElementById('enemy-health-bar'),
            enemyHealthBarWrapper: document.getElementById('enemy-health-bar-wrapper'),
            enemyView: document.getElementById('enemy-view'),
            enemyEmoji: document.getElementById('enemy-emoji'),
            enemyName: document.getElementById('enemy-name'),
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
            store: document.getElementById('store'),
            storeName: document.getElementById('store-name'),
            storeItems: document.getElementById('store-items'),
            updateStoreBtn: document.getElementById('updateStoreBtn'),
            buttonStoreWrapper: document.getElementById('button-store-wrapper'),
            updateStorePrice: document.getElementById('updateStorePrice'),
            map: document.getElementById('map'),
            levels: document.getElementById('levels'),
        };

        // унікальний ID
        function uniqueId() {
            return Date.now() + Math.floor(Math.random() * 1000);
        }

        // класичний рандом
        function rand(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
        }

        // вибрати єдине випадкове значення з масиву
        function chooseOne(list) {
            if (!Array.isArray(list) || list.length === 0) {
                throw new Error("Input must be a non-empty array");
            }
            const index = Math.floor(Math.random() * list.length);
            return list[index];
        }

        // Найпростіший та правильний варіант: Fisher–Yates Shuffle
        function shuffleArray(arr) {
            for (let i = arr.length - 1; i > 0; i--) {
                const j = Math.floor(Math.random() * (i + 1)); // випадковий індекс
                [arr[i], arr[j]] = [arr[j], arr[i]];           // свопаємо
            }
            return arr;
        }
        // в прототипах їм якось лучшєє буде
        Array.prototype.shuffle = function () {
            return shuffleArray(this);
        };
        Array.prototype.randOne = function () {
            return chooseOne(this);
        };

        // дивна рекалькуляція всіх параметрів
        function paramToValue(valuesSum) {
            const raw = 0.6 * Math.pow(valuesSum, 3) + 0.5 * Math.pow(valuesSum, 2) + 4 * valuesSum;
            return Math.round(raw / 5) * 5;
        }

        // нова ціна для предмета
        function newPriceForItem(item) {
            let paramsSum = 0;
            if (item.attack) paramsSum += (item.attack || 0);
            if (item.defense) paramsSum += (item.defense || 0);
            if (item.maxHealth) paramsSum += (item.maxHealth || 0) / 5;
            if (item.critChance) paramsSum += (item.critChance || 0) / 0.1;

            return paramsSum < 1 ? 2 : paramToValue(paramsSum);
        }

        // new prices
        function newPrices(listOfItems) {
            let newList = [];
            for (i = 0; i < listOfItems.length; i++) {
                let item = {...listOfItems[i]};
                let newPrice = newPriceForItem(item);

                if (['amulet', 'book'].includes(item.type)) {
                    newPrice = Math.round(newPrice * 1.25 / 5) * 5; // всі амулети дорожче на 25%
                } else if (['relic'].includes(item.type)) {
                    newPrice = Math.round(newPrice * 1.5 / 5) * 5; // всі амулети дорожче на 50%
                } 

                //console.log(`${item.name} => OLD PRICE[${item.value}] => NEW PRICE[${newPrice}]`);
                item.value = newPrice;
                newList.push(item);
            }
            return newList;
        }

        // recalculate all Prices
        function recalculateAllPrices() {
            weapons = newPrices(weapons);
            armors = newPrices(armors);
            artifacts = newPrices(artifacts);
        }

        // 🎲 Вибір з урахуванням шансів
        function weightedRandomStore(excludeTypes = []) {
            // вибираєм всі типи крамниць які доступні для спавну і не світяться у списку історій
            const pool = storeTypes.filter(s => !excludeTypes.includes(s.type) && s.isSpawnable);
            
            const totalChance = pool.reduce((sum, s) => sum + s.chance, 0);
            let rand = Math.random() * totalChance;

            for (let storePool of pool) {
                rand -= storePool.chance;
                if (rand <= 0) return storePool;
            }

            // fallback, якщо щось пішло не так
            return pool[pool.length - 1];
        }

        // 🚀 Вибір з історією
        function chooseStore() {
            const storeData = weightedRandomStore(lastChosenStores);

            // оновити історію
            lastChosenStores.push(storeData.type);
            if (lastChosenStores.length > storeHistoryLimit) {
                lastChosenStores.shift(); // прибираємо найстаріший
            }

            return storeData;
        }

        function getEnemyDefense(enemy) {
            let enemyDefense = enemy.defense;
            if (enemy.item != null && enemy.item.defense) enemyDefense += enemy.item.defense;
            return Math.max(1, enemyDefense);
        }

        function getEnemyAttack(enemy) {
            let enemyAttack = enemy.attack;
            if (enemy.item != null && enemy.item.attack) enemyAttack += enemy.item.attack;
            return Math.max(1, enemyAttack);
        }

        function getEnemyMaxHealth(enemy) {
            let enemyMaxHealth = enemy.maxHealth;
            if (enemy.item != null && enemy.item.maxHealth) enemyMaxHealth += enemy.item.maxHealth;
            return Math.max(1, enemyMaxHealth);
        }

        function addTerraLight(playerX, playerY, dist = 1) {
            for (j = playerY - dist; j <= playerY + dist; j++) {
                for (i = playerX - dist; i <= playerX + dist; i++) {
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

                const baseSize = icons.frames[imgData.image].sourceSize.w;//64;
                const scaling = parseInt(size) / baseSize;

                const posX = (icons.frames[imgData.image].frame.x || 1) * scaling;
                const posY = (icons.frames[imgData.image].frame.y || 1) * scaling;
                const atlasX = icons.meta.size.w * scaling;
                const atlasY = icons.meta.size.h * scaling;

                const emojiStyle = `${extraStyle != '' ? extraStyle+'; ' : ''}display: inline-block; vertical-align: bottom; width:${size}; height:${size}; background-position: -${posX}px -${posY}px; background-size: ${atlasX}px ${atlasY}px;`;
                // замінюєм емоджі
                return `<span class="emoji-sprite emoji-replaced" style="${emojiStyle}"></span>`;
            }
            // лишаєм емоджі якщо нічо немає
            return emoji;
        }

        // функція для витягування масок
        function addEmojiMask(emoji = '❤️', size = '20px', subtype = 0, extraStyle = '') {
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

                // маски немає
                if (maskIcons.frames[imgData.image] == undefined) return false;

                const maskData = maskIcons.frames[imgData.image];

                const baseSize = maskData.sourceSize.w;//64;
                const scaling = parseInt(size) / baseSize;

                const posX = (maskData.frame.x || 1) * scaling;
                const posY = (maskData.frame.y || 1) * scaling;
                const atlasX = maskIcons.meta.size.w * scaling;
                const atlasY = maskIcons.meta.size.h * scaling;

                const emojiStyle = `${extraStyle != '' ? extraStyle+'; ' : ''}display: inline-block; vertical-align: bottom; width:${size}; height:${size}; background-position: -${posX}px -${posY}px; background-size: ${atlasX}px ${atlasY}px;`;
                // замінюєм емоджі
                return `<span class="emoji-sprite emoji-replaced emoji-mask" style="${emojiStyle}"></span>`;
            }
            // маски немає
            return false;
        }

        // типова для гравця іконка
        function addEmojiPlayer(emoji = '❤️', size = '20px') {
            return addEmoji(emoji, size, undefined, extraStyleMainIcons);
        }

        // типові кіонки для зброх, броні, амулетів, перснів, книжок і реліквій
        function addEmojiItem(emoji = '❤️', subtype = 0, specialParams = {}) {
            return addEmoji(emoji, '64px', subtype, specialParamsToStyle(specialParams));
        }

        // перетворює спец параметри на стилі
        function specialParamsToStyle(specialParams = {}) {
            let itemExtraStyles = [];

            for (const [key, value] of Object.entries(specialParams)) {
                if (key === 'hue-rotate') itemExtraStyles.push(`${key}(${value}deg)`);
                else itemExtraStyles.push(`${key}(${value})`);
            }

            return itemExtraStyles.length ? `filter:${itemExtraStyles.join(' ')}` : '';
        }

        // один з ворогів рухається
        function moveRandomEnemy() {
            const _koords = [-1, 0, 1];
            let enemyMoves = false;

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

                            enemyMoves = true;
                        }
                    }
                }
            }

            // після того як порухали воріженьку перевіряєм що в нас є голодні вороги
            if (enemyMoves && Math.random() < 0.25) {
                const hungryEnemies = findEnemiesByAbilities('hungry');
                if (!hungryEnemies.length) return;

                const enemy = chooseOne(hungryEnemies);
                const fruitCells = findCellByTypes('fruit');
                fruitCells.forEach((fruit, index) => {
                    // ворог зжер ніштяк
                    if (isNeighbour(enemy.position, fruit.position)) {
                        addLog(`🍽️ ${enemy.emoji} ${enemy.type} З'їв ${fruit.fruit.emoji} ${fruit.fruit.name}!`, 'enemy');

                        gameMap[fruit.position.y][fruit.position.x] = { type: 'empty', emoji: emptyEmoji };
                        return;
                    }
                });
            }
        }

        function generateObstacleCell() {
            const obstacleType = Math.random() < 0.7 ? 'tree' : 'mountain';
            return {
                type: 'obstacle',
                obstacle: obstacles.find(o => o.type === obstacleType),
                emoji: obstacleType === 'tree' ? chooseOne(['🌳', '🌲']) : '🗻',
                passable: false
            };
        }

        function carveTunnel(gameMap, starPoint, desiredRatio = 0.35) {
            const size = gameMap.length;
            const totalCells = size * size;
            const targetEmpty = Math.floor(totalCells * desiredRatio);

            // Стартова точка: центр
            let x = starPoint.x;
            let y = starPoint.y;

            // Перетворити початкову клітинку
            gameMap[y][x] = { type: 'empty', emoji: emptyEmoji };
            let carved = 1;

            const dirs = [
                { dx: 0, dy: -1 }, // up
                { dx: 1, dy: 0 },  // right
                { dx: 0, dy: 1 },  // down
                { dx: -1, dy: 0 }  // left
            ];

            while (carved < targetEmpty) {
                const dir = dirs[Math.floor(Math.random() * dirs.length)];
                const nx = x + dir.dx;
                const ny = y + dir.dy;

                if (nx >= 1 && ny >= 1 && nx < (size - 1) && ny < (size - 1)) {
                    x = nx;
                    y = ny;

                    const cell = gameMap[y][x];
                    if (cell.type === 'obstacle') {
                        gameMap[y][x] = { type: 'empty', emoji: emptyEmoji };
                        carved++;
                    }
                }
            }
        }

        function spawnLevelList() {
            elements.levels.innerHTML = '';
            const levelsCounter = levelsCompleted.length + 1;

            for (let i = 0; i <= levelsCounter; i++) {
                const floorNum = i;
                // б'єм локації по парам на кожен рівень гравця - 2 флори, перший звичайний, другий із крамницею
                // const levelNum = i == 0 ? 0 : Math.ceil((floorNum + 1) / 2); // зібльшення рівня через 1
                const levelNum = i;
                // перевіряєм чи цей рівень вже пройдений
                const isCompleted = levelsCompleted[i - 1] != undefined ? ' completed' : '';
                const storeEmoji = (floorNum % 2 == 0 && i != 0) ? addEmoji('🏬') : '';

                let temp = document.createElement('div');
                    temp.innerHTML = `<button class="levels-selector${isCompleted}" data-level="${levelNum}" data-floor="${floorNum}">
                                        ${floorNum == 0 ? 'Селище' : `Рівень ${floorNum} ${storeEmoji}` }
                                      </button>`;
                let element = temp.firstElementChild;
                    element.addEventListener('click', () => {
                        // мерців не пускаєм
                        if (player.health < 1) {
                            addLog('💀 Спочатку Вам треба ожити!', 'enemy', 'black');
                            return
                        }
                        // встановлюєм зачищену кімнату до вибраного рівня
                        player.clearedRooms = (i - 1);
                        //console.log(player.clearedRooms);
                        player.inLevelSelection = false;
                        //console.log(`clicked ${levelNum}`);
                        elements.levels.style.display = 'none';
                        elements.map.style.display = 'grid';
                        elements.gambleBtn.style.display = 'inline-block';

                        tabManager.setTab(['map-block', 'inventory', 'slots']);
                        initMap(levelNum);
                    });

                elements.levels.appendChild(element);
            }

            document.querySelector(`.levels-selector[data-floor="${levelSelected}"]`).focus();
        }

        // Ініціалізація карти
        function initMap(mapLevel = 0) {
            gameMap = [];
            enemies = [];
            elements.map.innerHTML = '';

            // MAIN LEVEL PARAMETER SET
            currentMapLevel = Math.max(1, mapLevel);

            //player.position = { x: Math.floor(mapSize/2), y: Math.floor(mapSize/2) };
            player.position = {x: rand(1, mapSize - 2), y: rand(1, mapSize - 2)};
            
            // спалюєм сліди перебування гравця на карті
            resetTerra();
            // створюєм карту
            const savedData = gatherAllMapData();
            let tmpDensity = 0.45 + Math.random() * 0.15;
            if ([1,2].includes(mapLevel)) tmpDensity = 0.25;
            if ([3,4].includes(mapLevel)) tmpDensity = 0.35;
            if ([5,6].includes(mapLevel)) tmpDensity = 0.45;

            if (mapLevel == 0) {
                generateMapByTemplate(preparedStartLevel);
                updateMap();
                return;
            }
            regenerateMap(player.position, tmpDensity, savedData);
            // Додаємо харчування
            spawnFruits();
            // сундук ліпший друг
            spawnChest();
            // Додаємо ворогів
            spawnEnemies();
            // прибираєм крамницю з карти
            deleteStore();

            // та артефакти на карту але тільки для непройденого першого рівня
            if (mapLevel == 1 && levelsCompleted.length == 0) {
                spawnArtifacts();
            }
            updateMap();
        }

        // перестворюєм карту
        function regenerateMap(playerPosition, density = 0.5, cellsData = []) {
            elements.map.innerHTML = '';
            gameMap = [];

            // робим всі точки непрохідними 
            for (let y = 0; y < mapSize; y++) {
                gameMap[y] = [];
                for (let x = 0; x < mapSize; x++) {
                    gameMap[y][x] = generateObstacleCell();
                }
            }

            // пробиваєм шлях
            carveTunnel(gameMap, playerPosition, density);
            
            // забиваєм контентом
            for (let y = 0; y < mapSize; y++) {
                for (let x = 0; x < mapSize; x++) {
                    const cellContent = gameMap[y][x];
                    const cell = document.createElement('div');

                    cell.className = 'map-cell';
                    cell.dataset.x = x;
                    cell.dataset.y = y;
                    cell.textContent = cellContent.emoji;
                    
                    cell.addEventListener('click', () => movePlayer(x, y));
                    
                    elements.map.appendChild(cell);
                }
            }

            if (cellsData.length) {
                const emptyCells = getAllCellsDataByType();
                cellsData.forEach((cell) => {
                    const rPosition = chooseOne(emptyCells);
                    gameMap[rPosition.y][rPosition.x] = cell;
                });
            }
        }

        function generateMapByTemplate(templateData) {
            elements.map.innerHTML = '';
            gameMap = [];

            player.position = {x: rand(1, mapSize - 2), y: rand(1, mapSize - 2)};
            const y = templateData.findIndex(row => row.includes('🧙‍♂️'));
            const x = y !== -1 ? templateData[y].indexOf('🧙‍♂️') : -1;
            if (x !== -1) {
                player.position = { x, y };
            }

            for (let y = 0; y < mapSize; y++) {
                gameMap[y] = [];
                for (let x = 0; x < mapSize; x++) {
                    if (templateData[y] == undefined || templateData[y][x] == undefined) continue;
                    const templateElement = templateData[y][x];

                    if (obstacles.map(o => o.emoji).includes(templateElement)) {
                        const obsObj = obstacles.find(o => o.emoji === templateElement);
                        gameMap[y][x] = { type: 'obstacle', obstacle: obsObj, emoji: templateElement, passable: false };
                    } else if (storeTypes.map(s => s.emoji).includes(templateElement)) {
                        const localStoreType = storeTypes.find(s => s.emoji == templateElement).type;
                        currentStoreType = localStoreType;
                        const storeId = spawnStore(localStoreType, x, y);
                    } else if (templateElement == '🚪') {
                        gameMap[y][x] = { type: 'exit', emoji: '🚪' };
                    } else {
                        gameMap[y][x] = { type: 'empty', emoji: emptyEmoji };
                    }

                    // end
                    const cellContent = gameMap[y][x];
                    const cell = document.createElement('div');

                    cell.className = 'map-cell';
                    cell.dataset.x = x;
                    cell.dataset.y = y;
                    cell.textContent = cellContent.emoji;
                    
                    cell.addEventListener('click', () => movePlayer(x, y));
                    
                    elements.map.appendChild(cell);
                }
            }

            //updateMap();
        }

        function getAllCellsDataByType(cellType = 'empty') {
            let filteredMap = [];
            for (j = 0; j < gameMap.length; j++) {
                for (i = 0; i < gameMap[j].length; i++) {
                    if (gameMap[j][i].type == cellType && !enemies.filter(e => e.position.x == i && e.position.y == j).length) filteredMap.push({x:i,y:j});
                }
            }
            return filteredMap;
        }

        function gatherAllMapData() {
            let mapData = [];
            for (j = 0; j < gameMap.length; j++) mapData.push(...gameMap[j].filter(gm => !['obstacle', 'empty'].includes(gm.type)));
            return mapData;
        }

        // Оновлена функція для відображення ворогів на карті
        function updateMap() {
            const cells = document.querySelectorAll('.map-cell');
            
            visitedCells.add(`${player.position.x},${player.position.y}`);
            addTerraLight(player.position.x, player.position.y, 2);
            
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
                if (isNeighbour({x, y}, player.position, 3)) {
                    cell.classList.add('sight-cell');
                }
                
                if (x === player.position.x && y === player.position.y) {
                    cell.innerHTML = addEmoji(player.emoji, '30px');
                    cell.classList.add('player-cell');
                    cell.classList.add('sight-cell');
                    if (gameMap[y][x].type === 'store') cell.classList.add('store-cell');
                    cell.id = 'player-on-map';
                    return;
                }
                
                if (terraCognita.has(`${x},${y}`)) {
                    if (gameMap[y][x].type === 'obstacle') {
                        cell.classList.add('obstacle-cell');
                        cell.classList.add('tree-cell');
                        cell.innerHTML = addEmoji(gameMap[y][x].emoji, '30px');
                    }

                    if (gameMap[y][x].type == 'exit') {
                        cell.classList.add('exit-cell');
                        cell.innerHTML = addEmoji(`🚪`, '30px');
                    }

                    const enemy = enemies.find(e => e.position.x === x && e.position.y === y);
                    if (enemy && isNeighbour(enemy.position, player.position, 3)) {
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

                    if (gameMap[y][x].type === 'store') {
                        cell.innerHTML = addEmoji(gameMap[y][x].emoji, '30px');
                        cell.classList.add('store-cell');

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
                        } else {
                            cell.classList.add('money-cell');
                        }
                    }
                }
            });
        }

        function findEnemiesByAbilities(abilityName) {
            return enemies.filter(enemy => enemy.abilities.indexOf(abilityName) != -1 );
        }

        function findCellByTypes(typeName) {
            const found = [];

            for (let y = 0; y < gameMap.length; y++) {
                for (let x = 0; x < gameMap[y].length; x++) {
                    const tile = gameMap[y][x];
                    if (tile.type === typeName) {
                        found.push({ position: {x, y}, ...tile });
                    }
                }
            }

            return found;
        }

        function isNeighbour(position, targetPosition, dist = 1) {
            const dx = Math.abs(position.x - targetPosition.x);
            const dy = Math.abs(position.y - targetPosition.y);
            return (dx <= dist && dy <= dist) && !(dx === 0 && dy === 0);
        }

        function findPlayerNeighbours(enemyList) {
            const neighbors = enemyList.filter(enemy => {
                const dx = Math.abs(enemy.position.x - player.position.x);
                const dy = Math.abs(enemy.position.y - player.position.y);

                return dx <= 1 && dy <= 1 && !(dx === 0 && dy === 0);
            });
            return neighbors;
        }

        // Переміщення гравця
        function movePlayer(x, y) {
            if (x < 0 || y < 0 || x > (mapSize - 1) || y > (mapSize - 1)) {
                return;
            }
            if (player.health <= 0) {
                addLog('💀 Ви мертві і не можете рухатись!', 'system');
                return;
            }
            if (player.isBattle === true) {
                addLog('🚫 Під час битви не можна рухатись!', 'system');
                return;
            }
            if (player.inStore === true) {
                addLog('🏬 Обережно, Ви ж у крамниці!', 'system');
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

            // шукаєм поруч ворога з навичкою trap_master, з ймовірністю 33% втрапляєм у пастку
            const trapMasters = findPlayerNeighbours(findEnemiesByAbilities('trap_master'));
            if (trapMasters.length && Math.random() < 0.33) {
                const enemy = trapMasters[0];
                const enemyDamage = Math.max(1, getEnemyAttack(enemy) - player.defense + Math.floor(Math.random() * 5) - 2);

                player.health -= enemyDamage;
                addPopupMessage(`-${enemyDamage} ${addEmoji('❤️')}${addEmoji('💫')}`, document.getElementById('player-on-map'), {
                    color: '#f00',
                    fontSize: '20px',
                    horizontalOffset: 5
                });
                addLog(`💫${enemy.emoji} ${enemy.type} Влаштував пастку: -${enemyDamage}❤️!`, 'enemy');

                // можна вмерти
                startDeath(`💀 Ви загинули атрапивши у пастку ${enemy.emoji} ${enemy.type}!`);
                updateStats();
            }

            // є невеличка ймовірність що примара телепортується
            if (Math.random() < 0.1) {
                let ghostEnemies = findEnemiesByAbilities('ghost');
                if (ghostEnemies.length) {
                    let ghost = chooseOne(ghostEnemies);
                    const emptyCell = chooseOne(findCellByTypes('empty'));
                    ghost.position = emptyCell.position;
                }
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
                addPopupMessage(`${addEmoji('⚔️', '32px')}`, tmpTarget, {
                    color: '#ff0',
                    fontSize: '20px',
                    horizontalOffset: 5
                });

                let newEnemy = {...enemies[enemyIndex]};
                newEnemy.health = getEnemyMaxHealth(newEnemy);

                updateEnemyStats(newEnemy);
                elements.enemyEmoji.textContent = newEnemy.emoji;
                elements.enemyEmoji.style.filter = `grayscale(0%)`;

                elements.vs.innerHTML = addEmoji('⚔️', '64px');
                elements.vs.style.visibility = 'visible';
                elements.enemyStats.style.visibility = 'visible';
                elements.enemyHealthBarWrapper.style.visibility = 'visible';
                
                showEnemy(newEnemy);
                setTimeout(function() {
                    startBattle(newEnemy);
                }, 1500);
                return;
            }
            
            // Перевіряємо чи є там артефакт
            if (gameMap[y][x].type === 'artifact') {
                // Перевіряємо чи є там квиток
                if (gameMap[y][x].artifact.type == 'ticket') {
                    pickUpTicket(x, y);
                } else {
                    pickUpArtifact(x, y);
                }
                return;
            }
            // Перевіряємо чи є там фрукт
            if (gameMap[y][x].type === 'fruit') {
                pickUpFruit(x, y);
                return;
            }

            // Перевіряємо чи є крамниця
            player.atStore = false;
            tabManager.removeTab('store');
            if (player.health > 0) {
                elements.gambleBtn.style.display = 'inline-block';
                elements.storeBtn.style.display = 'none';
            }

            if (gameMap[y][x].type === 'store') {
                /*const currentStore = storeTypes.find(e => e.type == currentStoreType);*/
                const currentStore = getStoreHubById(gameMap[y][x].id);

                player.atStore = true;
                elements.gambleBtn.style.display = 'none';
                elements.storeBtn.style.display = 'inline-block';

                tabManager.addTab('store');

                elements.enemyEmoji.innerHTML = addEmoji(currentStore.emojiTrader, '64px');
                elements.enemyEmoji.style.filter = `grayscale(0%)`;
                elements.vs.innerHTML = addEmoji('🤝', '64px');
                elements.vs.style.visibility = 'visible';

                elements.enemyName.innerHTML = currentStore.name;
                elements.enemyName.style.display = 'block';

                //return;
            } else {
                elements.enemyEmoji.innerHTML = addEmoji(emptyEmoji, '64px');
                elements.vs.style.visibility = 'hidden';
                elements.enemyStats.style.visibility = 'hidden';
                elements.enemyHealthBarWrapper.style.visibility = 'hidden';
                elements.enemyName.style.display = 'none';
            }

            // гравець покидає рівень
            if (gameMap[y][x].type === 'exit') {
                spawnLevelList();

                // виходим на вибір рівнів
                player.inLevelSelection = true;
                elements.levels.style.display = 'block';
                elements.map.style.display = 'none';
                elements.gambleBtn.style.display = 'none';

                tabManager.setTab(['levels', 'inventory']);

                document.querySelector(`.levels-selector[data-floor="${levelSelected}"]`).focus();
            }
            
            // Переміщуємо гравця
            player.position = { x, y };
            drawTabsInfo();
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

        // Підбираємо квиток
        function pickUpTicket(x, y) {
            const ticket = gameMap[y][x].artifact;
            const targetOnMap = document.querySelector(`.map-cell[data-x="${x}"][data-y="${y}"]`);

            addLog(`✨🎟️ Ви знайшли квиток! Використайте його для гри або у крамниці!`, 'artifact', '#4504ed');

            // Анімація
            addPopupMessage(`${addEmoji(ticket.emoji, '32px')}`, targetOnMap, {
                fontSize: '40px',
                horizontalOffset: 5
            });

            // Видаляємо артефакт з карти
            gameMap[y][x] = { type: 'empty', emoji: emptyEmoji };
            player.position = { x, y };

            player.tickets++;

            updateMap();
            updateStats();
            updateInventory();
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
            }

            // Анімація
            addPopupMessage(`${addEmoji(artifact.emoji, '32px', artifact.subtype)}`, targetOnMap, {
                fontSize: '40px',
                horizontalOffset: 5
            });
            
            // Видаляємо артефакт з карти
            gameMap[y][x] = { type: 'empty', emoji: emptyEmoji };
            player.position = { x, y };

            // піднімаєм предмет
            pickUpItem(artifact);
            
            updateMap();
            updateInventory();
        }

        // функція із автоекіпом
        function pickUpItem(item, forceEquip = false) {
            // кладем в торбу
            player.inventory.push(item);

            // покращуєм логіку
            const isEquipped = !!player.equipment[item.type];
            const isEquipable = equipableTypes.includes(item.type);
            const isForced = !!forceEquip;

            const canUseItem = (isEquipable && (!isEquipped || (isForced && isEquipped))) || (!isEquipable && isForced);

            if (canUseItem) {
                useItem(player.inventory.length - 1);
            }
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
            addPopupMessage(`+${actualHeal}${addEmojiPlayer('❤️')}`, targetOnMap, {
                color: fruit.color,
                fontSize: '24px'
            });
            
            // Повідомлення з відсотком
            let percentText = '';
            if (fruit.healPercent === 0.25) percentText = ' (25%)';
            else if (fruit.healPercent === 0.5) percentText = ' (50%)';
            else percentText = ' (100%)';
            
            addLog(`🍏 Ви з'їли ${fruit.emoji} ${fruit.name} і відновили ${actualHeal} HP${percentText}!${overHealth > 0 ? ' Підвищення сил: +' + overHealth : ''}`, 'system');
            
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
                const goldFound = Math.floor(Math.random() * 10 * currentMapLevel) + 5;
                player.gold += goldFound;
                addLog(`💰 Ви знайшли скарб і отримали ${goldFound} золота!`, 'loot');

                addPopupMessage(`+${goldFound}${addEmojiPlayer('💰')}`, targetOnMap, {
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

                let goldFound = Math.floor(Math.random() * 5 * currentMapLevel) + 5;
                    goldFound = isGoldenChest ? goldFound * 3 : goldFound;

                // з одного сундука можна отримати від 3 до 5% досвіду необхідного для отримання рівня але не менше 10 од.
                // золотий сундук дає 2 рази більше
                const xptoNextByLevelMap = getXpByLevel(currentMapLevel);
                let xpFound = Math.max(10, Math.floor(xptoNextByLevelMap * ((3 + Math.random() * 2) / 100)));
                    xpFound = isGoldenChest ? xpFound * 2 : xpFound;

                player.gold += goldFound;
                player.xp += xpFound;

                const isTicketFound = (Math.random() < ticketSpawnChance) || isGoldenChest;
                checkLevelUp();

                let messageChest = `🎁 Ви відкрили ${chestName} і отримали ${goldFound} золота та ${xpFound} досвіду!`;
                if (gameMap[y][x].artifact != null) {
                    messageChest = `🎁 Ви відкрили ${chestName} і отримали ${goldFound} золота, ${xpFound} досвіду та знайшли ${gameMap[y][x].artifact.emoji} ${gameMap[y][x].artifact.name}!`;

                    // піднімає предмет
                    pickUpItem(gameMap[y][x].artifact);
                }

                addLog(messageChest, 'loot');

                // Анімація
                addPopupMessage(`+${goldFound}${addEmojiPlayer('💰')}`, targetOnMap, {
                    color: '#ff0',
                    fontSize: '20px'
                });
                addPopupMessage(`+${xpFound}${addEmojiPlayer('📈')}`, targetOnMap, {
                    color: '#ff0',
                    fontSize: '20px',
                    horizontalOffset: -20,
                });
                addPopupMessage(`${addEmoji(gameMap[y][x].artifact.emoji, '32px', gameMap[y][x].artifact.subtype)}`, targetOnMap, {
                    fontSize: '40px',
                    horizontalOffset: 30
                });

                // іноді ще можна знайти квиток
                if (isTicketFound) {
                    addLog(`✨🎟️ Ви знайшли квиток! Використайте його для гри або у крамниці!`, 'artifact', '#4504ed');
                    player.tickets++;
                    addPopupMessage(`${addEmoji('🎟️', '32px')}`, targetOnMap, {
                        fontSize: '40px',
                    });
                }

                // Видаляємо сундук
                gameMap[y][x] = { type: 'empty', emoji: emptyEmoji };
                updateStats();
                updateInventory();
                updateMap();
            }
        }

        // розподіл ворогів по рівням
        function getEnemyTypeCounts(playerLevel) {
            const totalEnemies = 3 + (playerLevel < 7 ? playerLevel : 10);

            // 🟡 Еліта: від 15% (рівень 1) до 30% (рівень 10+)
            let eliteRatio = 0.15;
            if (playerLevel >= 10) {
                eliteRatio = 0.30;
            } else if (playerLevel > 1) {
                const scale = (playerLevel - 1) / 9;
                eliteRatio = 0.15 + scale * (0.15);
            }

            // 🔴 Боси: від рівня 4 до 15%, завжди мінімум 1 після 3 рівня
            let bossRatio = 0;
            if (playerLevel >= 10) {
                bossRatio = 0.15;
            } else if (playerLevel >= 4) {
                const scale = (playerLevel - 5) / 7;
                bossRatio = 0.15 * scale;
            }

            let bossCount = Math.floor(totalEnemies * bossRatio);
            let eliteCount = Math.floor(totalEnemies * eliteRatio);

            // 🛡 Гарантуємо 1 боса з рівня 3
            if (playerLevel >= 5 && bossCount === 0) {
                bossCount = 1;
            }

            // 🔢 Коригуємо нормальних ворогів
            let normalCount = totalEnemies - bossCount - eliteCount;

            // Якщо нормальних менше нуля — віднімаємо від еліти (переважно)
            if (normalCount < 0) {
                const overflow = -normalCount;
                if (eliteCount >= overflow) {
                    eliteCount -= overflow;
                } else {
                    const rest = overflow - eliteCount;
                    eliteCount = 0;
                    bossCount = Math.max(1, bossCount - rest); // босів лишаємо хоча б 1
                }
                normalCount = 0;
            }

            return [
                { type: 'normal', count: normalCount },
                { type: 'elite', count: eliteCount },
                { type: 'boss', count: bossCount }
            ];
        }

        // дані по клітинці
        function getCell(x,y) {
            if (gameMap[y] == undefined || gameMap[y][x] == undefined) return { type: 'null', emoji: emptyEmoji };
            return gameMap[y][x];
        }

        // Спавнимо вихід із локації
        function spawnExit() {
            let exitFound = false;
            let attempts = 0;
            const obstacles = findCellByTypes('obstacle');

            do {
                const o = obstacles.randOne().position;
                if (
                    getCell(o.x, o.y - 1).type == 'empty' ||
                    getCell(o.x, o.y + 1).type == 'empty' ||
                    getCell(o.x - 1, o.y).type == 'empty' ||
                    getCell(o.x + 1, o.y).type == 'empty'
                ) {
                    gameMap[o.y][o.x] = { type: 'exit', emoji: emptyEmoji};
                    exitFound = true;
                }

                attempts++;
                if (attempts > 50) break;
            } while (!exitFound);
        }

        // Додаємо ворогів на карту
        function spawnEnemies() {
            // дані з к-стю ворогів і типами
            enemyCounts = getEnemyTypeCounts(currentMapLevel);
            
            enemyCounts.forEach((ec) => {
                for (let i = 0; i < ec.count; i++) {
                    spawnEnemy(ec.type);
                }
            });
        }

        function spawnEnemy(diffType = 'normal') {
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
                let enemy = generateEnemy(diffType);
                enemy.position = { x, y };
                enemies.push(enemy);
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
                    artifact: isGold ? makeItemMagic(item) : item,
                };
            }
        }

        // Додаємо артефакти на карту
        function spawnArtifacts(amount = -1) {
            const artifactCount = amount == -1 ? (2 + Math.floor(currentMapLevel / 3)) : amount;
            
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
                    // створюємо артефакт, ну або квиток
                    const item = (Math.random() >= ticketSpawnChance) ? generateArtifact() : {...ticket};
                    gameMap[y][x] = {
                        type: 'artifact',
                        emoji: item.emoji,
                        artifact: item
                    };
                }
            }
            
            // Додаємо скарби
            const treasureCount = amount == -1 ? 3 : amount;
            spawnGold(treasureCount);

            updateMap();
        }

        // spawn gold
        function spawnGold(treasureCount) {
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
        }

        function spawnItem(item) {
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
                gameMap[y][x] = {
                    type: 'artifact',
                    emoji: item.emoji,
                    artifact: item
                };
            }
        }

        function spawnFruits(amount = -1) {
            // фруктів не може бути більше 12 штук одночасно
            const maxFuitsAtMap = 12;
            // Кількість фруктів залежить від рівня (або встановленого значення)
            let fruitCount = amount == -1 ? (2 + Math.floor(currentMapLevel / 3)) : amount;
            // Рахуєм к-сть харчів
            let currentFoods = []; for (i = 0;i < gameMap.length;i++) { currentFoods.push(...gameMap[i].filter(food => food.type == 'fruit')); }
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
                    
                    if (rarityRoll > 0.9 && currentMapLevel > 3) {       // 10% шанс на виноград / стейк (рівень > 3)
                        fruitType = fruits.find(f => f.healPercent === 1.0);
                    } else if (rarityRoll > 0.6) {                   // 30% шанс на банан / піццу
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

        // спавнимо на мапі крамницю
        function spawnStore(storeType = 'general', needX = -1, needY = -1) {
            // зберігаєм тип крамниці на випадок оновлення асортименту
            currentStoreType = storeType;
            const uniqId = generateStore(storeType);

            let x, y;
            if (needX == -1 && needY == -1) {
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
            } else {
                x = needX;
                y = needY
            }

            gameMap[y][x] = {
                type: 'store',
                emoji: '🏬',
                storeType: storeType,
                id: uniqId,
            };

            updateStore();
            return uniqId;
        }

        // Функція для показу повідомлення
        function showGameMessage(header, message, duration = 0, addClass = '', callback) {
            const modal = document.getElementById('game-modal');
            const messageHeader = document.getElementById('modal-header');
            const messageElement = document.getElementById('modal-message');
            const okButton = document.getElementById('modal-ok');
            
            messageHeader.innerHTML = header;
            messageElement.innerHTML = message;
            modal.style.display = 'block';
            if (addClass != '') modal.classList.add(addClass);
            
            // Обробник кнопки OK
            okButton.onclick = function() {
                if (callback != undefined) {
                    setTimeout(callback, 500);
                };
                modal.style.display = 'none';
                if (addClass != '') modal.classList.remove(addClass);
            }
            
            // Автозакриття через вказаний час (якщо duration > 0)
            if (duration > 0) {
                setTimeout(() => {
                    modal.style.display = 'none';
                }, duration);
            }
            
            // Закриття при кліку поза вікном
            /*window.onclick = function(event) {
                if (event.target == modal) {
                    modal.style.display = 'none';
                }
            }*/

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

            // оновлюєм кнопку гембла
            updateGamblePrice();
            drawTabsInfo();
        }

        function signedValue(value) {
            if (value > 0) {
                //return `+${value}`;
                return `${value}`;
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
                let magicLevel = Math.abs(item.magicLevel || 0);
                    magicLevel = item.magicLevel != 0 ? ` ${(item.status || '')} ${(item.status || '')}-${(magicLevel)}` : '';

                itemElement.className = `item-slot ${magicLevel} item-${item.type}`;
                itemElement.innerHTML = getItemView(item, index, 'inventory');
                
                elements.inventoryItems.appendChild(itemElement);
            });
            
            elements.inventoryFullness.innerHTML = `(${player.inventory.length}${addEmoji('📦', '20px', undefined, 'vertical-align: text-bottom!important; margin-left: 4px;')})`;
            if (player.inventory.length === 0) {
                elements.inventoryItems.innerHTML = '<p>Інвентар порожній</p>';
                elements.inventoryFullness.innerHTML = '(Пусто)';
            }

            drawTabsInfo();
        }

        // Оновлюємо слот обладнання
        function updateEquipmentSlot(slot) {
            const element = elements[`${slot}Slot`];
            if (player.equipment[slot]) {
                const item = player.equipment[slot];

                element.innerHTML = getItemView(item, undefined, undefined, slot);
            } else {
                element.innerHTML = `
                    <div class="inventory-item">
                        <div class="item-name">Пусто</div>
                        <div class="item-image-background equipment">${addEmoji(emptySlotsEquipmentsEmojies[slot], '64px', 0)}</div>
                    </div>
                `;
            }
        }

        function updateStore() {
            const playerCell = player.getCurrentCell();
            if (playerCell.storeType == undefined) return;

            let localStoreData = getStoreHubById(playerCell.id);

            // якщо крамниця не може бути оновленою
            if (!localStoreData.isRefreshing) {
                elements.buttonStoreWrapper.classList.add('disabled');
            } else {
                elements.buttonStoreWrapper.classList.remove('disabled');
            }

            // оновлюєм кнопку оновлення
            if (player.tickets < 1) {
                elements.updateStorePrice.innerHTML = `${player.level * 25}${addEmoji('💰', '20px', undefined, 'vertical-align: text-bottom!important; margin-left: 4px;')}`;
                elements.updateStoreBtn.classList.remove('tickets');
            } else {
                elements.updateStorePrice.innerHTML = `${player.tickets}${addEmoji('🎟️', '20px', undefined, 'vertical-align: text-bottom!important; margin-left: 4px;')}`;
                elements.updateStoreBtn.classList.add('tickets');
            }

            elements.storeItems.innerHTML = '';

            localStoreData.listOfGoods.forEach((item, index) => {
                const itemElement = document.createElement('div');
                let magicLevel = Math.abs(item.magicLevel || 0);
                    magicLevel = item.magicLevel != 0 ? ` ${(item.status || '')} ${(item.status || '')}-${(magicLevel)}` : '';

                    let buyPricePromo = 0;
                    const buyPrice = Math.max(buyCoefficient, Math.floor(item.value * buyCoefficient));
                    if (item.promoValue != undefined) {
                        buyPricePromo = Math.max(buyCoefficient, Math.floor(item.promoValue * buyCoefficient));
                    }
                    const buyPriceTotal = (item.promoValue != undefined) ? buyPricePromo : buyPrice;

                itemElement.className = `item-slot ${magicLevel} item-${item.type}${buyPriceTotal > player.gold ? ' not-enough-gold': ''}`;
                itemElement.innerHTML = getItemView(item, index, 'store');

                elements.storeItems.appendChild(itemElement);
            });

            drawTabsInfo();
        }

        // порівняння параметрів предмета гравця і товару
        function comparePlayerParamValue(item, paramType) {
            if (equipableTypes.includes(item.type)) {
                const tmpEquipment = (player.equipment[item.type] || {attack:0, defense:0, maxHealth:0});
                const playerItemValue = (tmpEquipment[paramType] || 0);
                const compareItemValue = (item[paramType] || 0);

                if (playerItemValue < compareItemValue) return `<span style="color:#0f0;font-weight:bold;">${signedValue(item[paramType])}</span>`;
                else if (playerItemValue > compareItemValue) return `<span style="color:#ff5500;font-weight:bold;">${signedValue(item[paramType])}</span>`;
            }

            return `<span style="color:#fff;font-weight:bold;">${signedValue(item[paramType])}</span>`;
        }

        // відображення предмету
        // viewType ('inventory' - в рюкзаку, 'equipment' - те шо вдягнуте, 'store' - в крамниці)
        function getItemView(item, index = -1, viewType = 'equipment', equipmentSlot = '') {
            let bonusText = '';
            if (item.attack) bonusText += ` <span class="nowrap">⚔️${viewType == 'store' ? comparePlayerParamValue(item, 'attack') : signedValue(item.attack)}</span>`;
            if (item.defense) bonusText += ` <span class="nowrap">🛡️${viewType == 'store' ? comparePlayerParamValue(item, 'defense') : signedValue(item.defense)}</span>`;
            if (item.maxHealth) bonusText += ` <span class="nowrap">❤️${viewType == 'store' ? comparePlayerParamValue(item, 'maxHealth') : signedValue(item.maxHealth)}</span>`;
            if (item.critChance) bonusText += ` <span class="nowrap">💥${Math.floor(item.critChance*100)}%</span>`;
            if (item.description) bonusText = ` ${item.description}`;
            
            const currentSubtype = typeof item.subtype != 'undefined' ? item.subtype : 0;
            const currentSpecialParams = typeof item.specialParams != 'undefined' ? item.specialParams : {};
            let itemSpecStyle = specialParamsToStyle(currentSpecialParams);
                itemSpecStyle = itemSpecStyle != '' ?  `color:#0ff;${itemSpecStyle};text-shadow: 2px 2px 0 black;` : itemSpecStyle ;

            const magicLevel = Math.abs(item.magicLevel || 0);
            const magicClass = (magicLevel != 0) ? `${item.status} ${item.status}-${magicLevel}` : `${(item.status || '')}`;

            const itemEmojiMask = addEmojiMask(item.emoji, '64px', currentSubtype, itemSpecStyle);
            const itemEmoji = addEmojiItem(item.emoji, currentSubtype, itemEmojiMask != false ? '' : currentSpecialParams);

            const typeEmoji = addEmoji(item.type.startsWith('potion') ? equipmentEmojies['potion'] : equipmentEmojies[item.type], '16px', -1);
            const typeEmojiSubInfo = `<div class="item-type-subinfo ${item.type.startsWith('potion') ? 'potion' : item.type}">${typeEmoji}</div>`;

            const equipmentTypeIndex = equipableTypes.indexOf(equipmentSlot);
            const equipmentSubInfo = (equipmentTypeIndex != -1 && viewType == 'equipment') ? `<div class="item-subinfo">ALT+${equipmentTypeIndex+1}</div>` : '';
            //const equipmentShadowImage = (equipmentTypeIndex != -1 && viewType == 'equipment') ? `<div class="item-image-background">${itemEmoji}</div>` : '';
            const equipmentShadowImage = `<div class="item-image-background ${viewType}">${itemEmoji}</div>`;

            // тепер продаєм виключно в магазині
            const canSellitem = (item.canSell !== false && tabManager.hasTab('store'));

            const inventoryIndex = (index != -1 && viewType == 'inventory') ? `` : '';
            const inventorySubInfo = (index != -1 && index < 9 && viewType == 'inventory') ? `<div class="item-subinfo-up">[ ${index+1} ]</div><div style="${canSellitem == false ? 'display:none;' : ''}" class="item-subinfo">SHIFT+${index+1}</div>` : '';

            let buyPrice = 0;
            let buyPricePromo = 0;
            let buyPriceTotal = 0;
            if (index != -1 && viewType == 'store') {
                buyPrice = Math.max(buyCoefficient, Math.floor(item.value * buyCoefficient));
                if (item.promoValue != undefined) {
                    buyPricePromo = Math.max(buyCoefficient, Math.floor(item.promoValue * buyCoefficient));
                }
                buyPriceTotal = (item.promoValue != undefined) ? buyPricePromo : buyPrice;
            }

            const inventoryActions = (index != -1 && viewType == 'inventory')
                ? `<div class="item-actions">
                        <div class="item-action" onclick="useItem(${index})">${item.type.startsWith('potion') ? 'Випити' : 'Екіпірувати'}</div>
                        ${canSellitem !== false ? `<div class="item-action" onclick="sellItem(${index})">Продати (${Math.max(1, Math.floor(item.value * sellCoefficient))}💰)</div>` : ''}
                    </div>` : '';
            const equipmentActions = (equipmentTypeIndex != -1 && viewType == 'equipment')
                ? `<div class="item-actions">
                        <div class="item-action" onclick="unequipItem(${equipmentTypeIndex})">Зняти</div>
                    </div>` : '';
            let storeActions = '';
            if (index != -1 && viewType == 'store') {
                if (buyPriceTotal <= player.gold) {
                    storeActions = `<div class="item-actions">
                                        <div class="item-action" onclick="buyItem(${index})">${buyPriceTotal}💰 Купити</div>
                                        <div class="item-action" onclick="buyItem(${index}, true)">${buyPriceTotal}💰 ... і ${item.type.startsWith('potion') ? 'випити' : 'екіпірувати'}</div>
                                    </div>`;
                } else {
                    storeActions = `<div class="item-actions"><div class="item-action">Недостатньо коштів</div></div>`;
                }
            }
            const storePriceBlock = (index != -1 && viewType == 'store')
                ? `<div class="item-desc item-price">
                        <span class="artifact-bonus store-price${(buyPricePromo != 0 ? ' store-price-old' : '')}">${buyPrice}💰</span>${(buyPricePromo != 0 ? ' <span class="store-price-promo">' + buyPricePromo + '💰</span>' : '')}
                    </div>` : '';

            return `
                <div class="inventory-item ${magicClass}">
                    <div class="item-name">${inventoryIndex}${item.name}</div>
                    ${buyPricePromo != 0 ? `<div class="promo-tag promo-${item.promoPercent}">-${item.promoPercent}%</div>` : ''}
                    <div class="item-image">${itemEmojiMask != false ? `${itemEmojiMask}` : ''}${itemEmoji}</div>
                    ${equipmentShadowImage}
                    <div class="item-desc">
                        <span class="artifact-bonus">${bonusText != '' ? bonusText : `&nbsp;`}</span>
                    </div>
                    ${storePriceBlock}
                    ${inventorySubInfo}
                    ${equipmentSubInfo}
                    ${typeEmojiSubInfo}
                </div>
                ${equipmentActions}
                ${inventoryActions}
                ${storeActions}
            `;
        }

        // створюєм предмети для купівлі
        /* storeType:
            general - все по троху
            armory - виключно зброя і броня
            jewelry - ювелірка: кільця і амулети
            library - бібліотека/книгарня
            antiques - антикваріат - виключно артефакти
            medic - лєчілка + еліксири (1-2 штукі)
            mystic - містичний магаз з оним типом артефакту у різних варіаціях

            id - вказуєм коли треба перегенерувати асортимент для вже існуючої крамниці
        */
        function generateStore(storeType = 'general', id = -1) {
            // множник для товстих магазинів
            const storeFullness = Math.random() < 0.05 ? 2 : 1;

            // 5% ймовірність появи товару зі знижкою в 75%
            const promoChance = 0.05;

            // макс. 12 прдметів в крамничці
            const itemsToBuy = Math.min(rand(2, 5) * storeFullness, 8);
            const additionalArtifacts = Math.min(rand(1, 3) * storeFullness, 4);

            const storeData = storeTypes.find(e => e.type == storeType);

            // нова структра крамничок
            let storeHub = {...storeData, id: (id === -1 ? uniqueId() : id), listOfGoods: []};

            elements.storeBtn.innerHTML = `${storeData.emoji} ${storeData.name} L:${currentMapLevel} [S]`;
            // барахолка
            if (storeType == 'flea') {
                storeHub.listOfGoods.push({...weapons[0]});
                storeHub.listOfGoods.push({...armors[0]});
            // звичайна крамниця з усіма товарами але по троху
            } else if (storeType == 'general') {
                for (i = 0; i < itemsToBuy; i++) {
                    let tmpItem;
                    // невеличкий шанс на предмет рівнем більше
                    if (Math.random() < 0.08) tmpItem = generateItemByLevel(currentMapLevel + 1, true, undefined, true);
                    else tmpItem = generateItem(true, undefined, true);
                    if (tmpItem != null) storeHub.listOfGoods.push(tmpItem);
                }
                for (i = 0; i < additionalArtifacts; i++) {
                    let tmpItem = generateItem(true, undefined, true, artifacts);
                    if (tmpItem != null) storeHub.listOfGoods.push(tmpItem);
                }
            // зброярня - тільки зброя і броня
            } else if (storeType == 'armory') {
                for (i = 0; i < (itemsToBuy + additionalArtifacts); i++) {
                    let tmpItem = generateItem(true, undefined, true, [...weapons, ...armors]);
                    if (tmpItem != null) storeHub.listOfGoods.push(tmpItem);
                }
            // ювелірка - амулети і кільця
            } else if (storeType == 'jewelry') {
                for (i = 0; i < (itemsToBuy + additionalArtifacts); i++) {
                    let tmpItem = generateItem(true, undefined, true, artifacts.filter(a => ['amulet', 'ring'].includes(a.type)));
                    if (tmpItem != null) storeHub.listOfGoods.push(tmpItem);
                }
            // книгарня - книжечки і дуже рідко якийсь релікт
            } else if (storeType == 'library') {
                for (i = 0; i < (itemsToBuy + additionalArtifacts); i++) {
                    let tmpItem = generateItem(true, undefined, true, artifacts.filter(a => ['book'].includes(a.type)));
                    if (tmpItem != null) storeHub.listOfGoods.push(tmpItem);
                }
                // шось дуже рідкісне на рівень потужніше за рівень мапи
                if (Math.random() < 0.25) {
                    let tmpItem = generateItemByLevel(currentMapLevel + 1, true, undefined, true, artifacts.filter(a => ['relic'].includes(a.type)));
                    if (tmpItem != null) storeHub.listOfGoods.push(makeItemMagic(tmpItem));
                }
                // + рідкісний еліксирчік
                if (Math.random() < 0.25) {
                    let tmpItem = {...potions[rand(0, potions.length - 1)]};
                    if (tmpItem != null) storeHub.listOfGoods.push(tmpItem);
                }
            // антиквар - релікти і невеличка жменька з амулетів, кілець і книжок
            } else if (storeType == 'antiques') {
                for (i = 0; i < itemsToBuy; i++) {
                    let tmpItem = generateItem(true, undefined, true, artifacts.filter(a => ['relic'].includes(a.type)));
                    if (tmpItem != null) storeHub.listOfGoods.push(tmpItem);
                }
                for (i = 0; i < additionalArtifacts; i++) {
                    let tmpItem = generateItem(true, undefined, true, artifacts.filter(a => ['amulet', 'ring', 'book'].includes(a.type)));
                    if (tmpItem != null) storeHub.listOfGoods.push(tmpItem);
                }
            // містична лавка - 3 рандомні предмети у перемагічених варіантах
            } else if (storeType == 'mystic') {
                // 3 рандомні речі подвійної магічності в різних варіаціях
                let magicItem;
                for (j = 0; j < 3 ; j++) {
                    magicItem = chooseOne(artifacts);
                    for (i = 0; i < rand(1, 4); i++) {
                        storeHub.listOfGoods.push(makeItemMagicNew(magicItem, 0.45));
                    }
                }
            }

            // додаєм товар зі знижкою
            storeHub.listOfGoods.forEach((storeItem) => {
                if (Math.random() < promoChance) {
                    storeItem.promoPercent = [50, 75, 95].randOne();
                    storeItem.promoValue = Math.max(1, Math.floor(storeItem.value * (1 - storeItem.promoPercent / 100)));
                }
            });

            storeHub.listOfGoods.sort((a, b) => {
                // 1️⃣ Товари з promoValue завжди перші
                const aPromo = 'promoValue' in a;
                const bPromo = 'promoValue' in b;

                if (aPromo !== bPromo) {
                    return bPromo - aPromo; // true > false, тобто: якщо b має promo, то йде вище
                }

                // 2️⃣ Сортування по type
                const orderA = equipableTypes.indexOf(a.type);
                const orderB = equipableTypes.indexOf(b.type);

                if (orderA !== orderB) {
                    return orderA - orderB;
                }

                // 3️⃣ Сортування по value (від більшого до меншого)
                return b.value - a.value;
            });

            // при перегенерації зберігаєм id
            const storeHubExisted = getStoreHubById(storeHub.id);
            //const localStoreIndex = allStoresHub.findIndex(h => h.id == storeHub.id);
            if (!storeHubExisted) allStoresHub.push(storeHub);
            else allStoresHub[storeHubExisted.index] = storeHub;

            return storeHub.id;
        }

        // видаляєм крамниці
        function deleteStore() {
            const storePosition = getAllCellsDataByType('store');
            if (storePosition.length > 0) {
                storePosition.forEach((storePos) => {
                    gameMap[storePos.y][storePos.x] = { type: 'empty', emoji: emptyEmoji };
                });
            }

            allStoresHub = [];
        }

        // знімаємо предмет
        function unequipItem(index) {
            if (index < 0 || index > 5 || player.equipment[equipableTypes[index]] == undefined || player.equipment[equipableTypes[index]] == null) return;

            const item = player.equipment[equipableTypes[index]];

            let healthPercentage = Math.min(player.health / player.maxHealth, 1);
            //console.log(`unequip => ${healthPercentage} => ${player.health} / ${player.maxHealth}`);

            player.inventory.push(item);
            player.equipment[equipableTypes[index]] = null;

            if (item.maxHealth) {
                updateStats();

                let currentHealth = player.health;
                // якщо рівень життя гравця до тимчасово збільшується, то робим гарну онімацію :)
                setTimeout(() => {
                    player.health = Math.floor(player.maxHealth * healthPercentage);
                    updateStats();
                }, currentHealth < player.maxHealth ? 250 : 0);
            }

            updateInventory();
            updateStats();
        }

        // Екіпіруємо предмет
        function equipItem(index) {
            const item = player.inventory[index];

            // врахуємо перерахунок співвідношення хп до макс хп
            let healthPercentage = Math.min(player.health / player.maxHealth, 1);
            //console.log(`equip   => ${healthPercentage} => ${player.health} / ${player.maxHealth}`);
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
            if (item.maxHealth || (unequipedItem != null && unequipedItem.maxHealth)) {
                updateStats();

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

        // Купляємо предмет
        function buyItem(index, forceEquip = false) {
            const playerCell = player.getCurrentCell();

            if (playerCell.storeType == undefined) return;
            let localStoreData = getStoreHubById(playerCell.id);

            if (localStoreData.listOfGoods[index] == undefined) return;

            const item = localStoreData.listOfGoods[index];

            const buyPrice = (item.promoValue != undefined) ? Math.max(1, Math.floor(item.promoValue * buyCoefficient)) : Math.max(1, Math.floor(item.value * buyCoefficient));
            if (player.gold < buyPrice) {
                addLog(`🏬💰 У вас недостатньо коштів для купівлі ${item.emoji} ${item.name}`, 'system');
                return;
            }

            pickUpItem(item, forceEquip);
            player.gold -= buyPrice;

            addPopupMessage(`-${buyPrice}${addEmojiPlayer('💰')}`, elements.playerEmoji, {
                color: '#ff0',
                fontSize: '20px',
                //delay: 500,
                horizontalOffset: 15,
            });

            // Видаляємо предмет з інвентаря крамниці
            localStoreData.listOfGoods.splice(index, 1);

            updateStats();
            updateInventory();
            updateStore();
        }

        // Продаємо предмет
        function sellItem(index) {
            const item = player.inventory[index];
            
            // Еліксири не можна продавати
            if (item.canSell === false) {
                addLog(`⚠️ ${item.emoji} ${item.name} не можна продати!`, 'system');
                return;
            }

            const sellPrice = Math.max(1, Math.floor(item.value * sellCoefficient)); // Продаємо за 50% вартості мінімальна ціна 1 копійка
            
            player.gold += sellPrice;
            player.inventory.splice(index, 1);
            
            addLog(`💰 Ви продали ${item.emoji} ${item.name} за ${sellPrice} золота`, 'sell');
            // сповіщення продажу
            addPopupMessage(`+${sellPrice}${addEmojiPlayer('💰')}`, elements.playerEmoji, {
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
                { 'rarity': 2, 'playerLevel': 3 },
                { 'rarity': 3, 'playerLevel': 5 },
                { 'rarity': 4, 'playerLevel': 8 },
                { 'rarity': 5, 'playerLevel': 11 },
                { 'rarity': 6, 'playerLevel': 14 },
                { 'rarity': 7, 'playerLevel': 17 },
            ];

            // 1. Відфільтровуємо лише ті rarity, які <= рівню гравця
            /*
            const availableRaritiesAll = rarityTable.filter(entry => entry.playerLevel <= playerLevel);
            const availableRarities = availableRaritiesAll.slice(-3); // тільки 3 найвищі
            */

            const availableRarities = rarityTable.filter(entry => entry.playerLevel <= playerLevel);
            if (availableRarities.length === 0) return null; // якщо нічого не доступно
           
            // 1. Вирізаємо нижнє
            /*const minAllowedRarity = Math.max(1, Math.floor(playerLevel / 3));

            const availableRarities = rarityTable.filter(entry =>
                entry.playerLevel <= playerLevel && entry.rarity >= minAllowedRarity
            );*/

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

        // Звична функція генерації предмета
        function generateItem(isForced = false, rarityBias = -1, mustBeModifed = false, itemHandyPool = null) {
            return generateItemByLevel(currentMapLevel, isForced, rarityBias, mustBeModifed, itemHandyPool);
        }

        // Генеруємо випадковий предмет
        function generateItemByLevel(itemLevel = 1, isForced = false, rarityBias = -1, mustBeModifed = false, itemHandyPool = null) {
            // 60% шанс отримати предмет
            if (Math.random() > 0.6 && !isForced) return null;
            
            // Вибираємо тип предмета (зброя, броня чи артефакт)
            const itemTypeRoll = Math.random();
            let itemPool;
            
            // 0-40% - weapons 41-80% - armors 81-85% - potions 86-100% - artifacts
            if (itemHandyPool == null) {
                if (itemTypeRoll < 0.4) itemPool = weapons;
                else if (itemTypeRoll < 0.8) itemPool = armors;
                else if (itemTypeRoll < 0.85) itemPool = potions;
                else itemPool = artifacts;
            } else {
                itemPool = itemHandyPool;
            }
            
            // Визначаємо рідкість на основі рівня левела
            let rarity = getBiasedRarity(itemLevel, rarityBias);
            // Фільтруємо предмети за рідкістю
            //const availableItems = itemPool.filter(item => item.rarity <= rarity);
            const availableItems = itemPool.filter(item => item.rarity == rarity);
            //const availableItems = itemPool.filter(item => [rarity - 1, rarity, rarity + 1].includes(item.rarity));

            //console.log(rarity);
            if (availableItems.length === 0) {
                if (isForced && itemHandyPool == null) return generateItemByLevel(itemLevel, isForced, rarityBias, mustBeModifed, itemHandyPool);
                else return null;
            }
            
            // Вибираємо випадковий предмет з доступних
            let itemTemplate = {...availableItems[Math.floor(Math.random() * availableItems.length)]};

            const isModified = mustBeModifed || (Math.random() < 0.25);

            if (isModified) {
                itemTemplate = makeItemMagic(itemTemplate);
            }
            
            // Створюємо копію предмета для гравця
            return {
                ...itemTemplate,
                id: uniqueId()
            };
        }

        // нова логіка створення магічного предмету
        // bonusRarity 0.0 - 1.0
        function makeItemMagicNew(magicItem, bonusRarity = 0) {
            // якщо предмет не з пулу екіпуємих - повертаєм його без змін
            if (!equipableTypes.includes(magicItem.type)) return magicItem;

            // є мізерний шанс отримати проклятий предмет
            if (Math.random() < 0.05) return makeItemCursed(magicItem);

            // є шанс отримати звичайний предмет
            if (Math.random() < 0.25) return {...magicItem};

            let itemTemplate = {...magicItem};
            // Особливі параметри
            //let itemSpecialParams = {};
            if (itemTemplate['specialParams'] == undefined) itemTemplate['specialParams'] = {};

            const mainRandomValue = Math.min(1.0, Math.random() + bonusRarity);
            //console.log([`ITEM CHANCE: ${mainRandomValue}`]);

            // встановлюєм рівні магічності предмету
            let magicLevel = 0;
            if (mainRandomValue < 0.6) magicLevel = 1;
            else if (mainRandomValue < 0.9) magicLevel = 2;
            else magicLevel = 3;

            for (ml = 0; ml < magicLevel; ml++) {
                itemTemplate = addRandomItemParam(itemTemplate);
            }

            if (magicLevel > 0) {
                itemTemplate.status = 'magic';
                itemTemplate.magicLevel = magicLevel;
                // підбираєм синоніми
                itemTemplate.name = findSynonym(itemTemplate.name);

                if (itemTemplate.type == 'book') {
                    itemTemplate.name = `"${generateBookTitle()}"`;
                    itemTemplate.subtype = rand(1, booksCounter);
                }
            }

            itemTemplate.value = newPriceForItem(itemTemplate);
            return itemTemplate;
        }

        function addRandomItemParam(itemTemplate) {
            let newItem = {...itemTemplate};

            const bonusType = ['attack', 'defense', 'maxHealth'].randOne();
            const bonusModif = 0.25 + (currentMapLevel * 0.05);

            if (bonusType == 'attack') {
                const attackParam = rand(1, Math.max(1, Math.floor((newItem.attack || 1) * bonusModif)));
                //console.log([`${newItem.name} => spec attack: ${(newItem.attack || 0)} + ${attackParam}`]);

                newItem.attack = (newItem.attack || 0) + attackParam;
                newItem['specialParams']['hue-rotate'] = rand(0, 359);
                if (newItem.type == 'weapon') {
                    newItem.critChance += Math.random() * 0.15;
                }
            } else if (bonusType == 'defense') {
                const defenseParam = rand(1, Math.max(1, Math.floor((newItem.defense || 1) * bonusModif)));
                //console.log([`${newItem.name} => spec defense: ${(newItem.defense || 0)} + ${defenseParam}`]);

                newItem.defense = (newItem.defense || 0) + defenseParam;
                newItem['specialParams']['contrast'] = rand(80, 150) / 100;
            } else if (bonusType == 'maxHealth') {
                const maxHealthParam = rand(1, Math.max(1, Math.floor((newItem.maxHealth || 1) * bonusModif)));
                //console.log([`${newItem.name} => spec health: ${(newItem.maxHealth || 0)} + ${maxHealthParam}`]);

                newItem.maxHealth = (newItem.maxHealth || 0) + maxHealthParam;
                newItem['specialParams']['brightness'] = rand(80, 150) / 100;
            }

            return newItem;
        }

        // робим звичайний предмет магічним
        function makeItemMagic(magicItem) {
            // test
            return makeItemMagicNew(magicItem);

            // є мізерний шанс отримати проклятий предмет
            if (Math.random() < 0.05) return makeItemCursed(magicItem);

            let itemTemplate = {...magicItem};
            // Особливі параметри
            let itemSpecialParams = {};

            let magicLevel = 0;
            if (equipableTypes.includes(itemTemplate.type)) {
                // hue main param
                //console.log([`name: ${itemTemplate.name}`]);

                // збільшуєм діапазон можливих значень з кожним рівнем гравця
                const bonusModif = 0.25 + (currentMapLevel * 0.05);
                if (Math.random() < 0.5) {
                    //const attackParam = rand(1, Math.max(1, Math.floor((itemTemplate.attack || 1) * 0.25)));
                    const attackParam = rand(1, Math.max(1, Math.floor((itemTemplate.attack || 1) * bonusModif)));
                    //console.log([`${itemTemplate.name} => spec attack: ${(itemTemplate.attack || 0)} + ${attackParam}`]);

                    itemTemplate.attack = (itemTemplate.attack || 0) + attackParam;
                    itemSpecialParams['hue-rotate'] = rand(0, 359);
                    if (itemTemplate.type == 'weapon') {
                        itemTemplate.critChance += Math.random() * 0.15;
                    }
                    magicLevel++;
                }
                if (Math.random() < 0.5) {
                    //const defenseParam = rand(1, Math.max(1, Math.floor((itemTemplate.defense || 1) * 0.25)));
                    const defenseParam = rand(1, Math.max(1, Math.floor((itemTemplate.defense || 1) * bonusModif)));
                    //console.log([`${itemTemplate.name} => spec defense: ${(itemTemplate.defense || 0)} + ${defenseParam}`]);

                    itemTemplate.defense = (itemTemplate.defense || 0) + defenseParam;
                    itemSpecialParams['contrast'] = rand(80, 150) / 100;
                    magicLevel++;
                }
                if (Math.random() < 0.5) {
                    //const maxHealthParam = rand(1, Math.max(1, Math.floor((itemTemplate.maxHealth || 1) * 0.25)));
                    const maxHealthParam = rand(1, Math.max(1, Math.floor((itemTemplate.maxHealth || 1) * bonusModif)));
                    //console.log([`${itemTemplate.name} => spec health: ${(itemTemplate.maxHealth || 0)} + ${maxHealthParam}`]);

                    itemTemplate.maxHealth = (itemTemplate.maxHealth || 0) + maxHealthParam;
                    itemSpecialParams['brightness'] = rand(80, 150) / 100;
                    magicLevel++;
                }

                /*if (Math.random() < 0.5) {
                    itemSpecialParams['drop-shadow'] = `0 0 1px rgb(${rand(0, 255)}, ${rand(0, 255)}, ${rand(0, 255)})`;
                }*/

                itemTemplate.value = newPriceForItem(itemTemplate);
            }

            if (magicLevel > 0) {
                itemTemplate.status = 'magic';
                itemTemplate.magicLevel = magicLevel;
                // підбираєм синоніми
                itemTemplate.name = findSynonym(itemTemplate.name);

                if (itemTemplate.type == 'book') {
                    itemTemplate.name = `"${generateBookTitle()}"`;
                    itemTemplate.subtype = rand(1, booksCounter);
                }
            }

            itemTemplate['specialParams'] = itemSpecialParams;
            return itemTemplate;
        }

        // робим звичайний предмт проклятим
        function makeItemCursed(magicItem) {
            let itemTemplate = {...magicItem};
            // Особливі параметри
            let itemSpecialParams = {};

            let magicLevel = 0;
            if (equipableTypes.includes(itemTemplate.type)) {
                const bonusModif = 0.25 + (currentMapLevel * 0.05);
                if (Math.random() < 0.5) {
                    //const attackParam = rand(1, Math.max(1, Math.floor((itemTemplate.attack || 1) * 0.25)));
                    const attackParam = rand(1, Math.max(1, Math.floor((itemTemplate.attack || 1) * bonusModif)));
                    //console.log([`${itemTemplate.name} => spec attack: ${(itemTemplate.attack || 0)} + ${attackParam}`]);

                    itemTemplate.attack = (itemTemplate.attack || 0) - attackParam;
                    magicLevel--;
                }
                if (Math.random() < 0.5) {
                    //const defenseParam = rand(1, Math.max(1, Math.floor((itemTemplate.defense || 1) * 0.25)));
                    const defenseParam = rand(1, Math.max(1, Math.floor((itemTemplate.defense || 1) * bonusModif)));
                    //console.log([`${itemTemplate.name} => spec defense: ${(itemTemplate.defense || 0)} + ${defenseParam}`]);

                    itemTemplate.defense = (itemTemplate.defense || 0) - defenseParam;
                    magicLevel--;
                }
                if (Math.random() < 0.5) {
                    //const maxHealthParam = rand(1, Math.max(1, Math.floor((itemTemplate.maxHealth || 1) * 0.25)));
                    const maxHealthParam = rand(1, Math.max(1, Math.floor((itemTemplate.maxHealth || 1) * bonusModif)));
                    //console.log([`${itemTemplate.name} => spec health: ${(itemTemplate.maxHealth || 0)} + ${maxHealthParam}`]);

                    itemTemplate.maxHealth = (itemTemplate.maxHealth || 0) - maxHealthParam;
                    magicLevel--;
                }

                itemTemplate.value = newPriceForItem(itemTemplate);
            }

            if (magicLevel < 0) {
                itemSpecialParams = {grayscale: 1, contrast: 1.5};
                itemTemplate.status = 'cursed';
                itemTemplate.magicLevel = magicLevel;
                // підбираєм синоніми
                itemTemplate.name = findSynonym(itemTemplate.name);

                if (itemTemplate.type == 'book') {
                    itemTemplate.name =  `"${generateBookTitle()}"`;
                    itemTemplate.subtype = rand(1, booksCounter);
                }
            }

            itemTemplate['specialParams'] = itemSpecialParams;
            return itemTemplate;
        }

        function generateBookTitle() {
            const maxBookNameLength = 15;
            const part2Numbers = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII"];
            const specNames = ["Saga de", "Saga"];

            let part1, part2;
            if (Math.random() < 0.5) {
                part1 = chooseOne(bookNameParts.part1);
                if (part1.length < 4 || specNames.includes(part1) || part1.endsWith("-")) {
                    part2 = chooseOne(bookNameParts.part2.filter(b2 => b2.length <= (15 - part1.length) && !part2Numbers.includes(b2)));
                } else {
                    part2 = chooseOne(bookNameParts.part2.filter(b2 => b2.length <= (maxBookNameLength - part1.length)));
                }
            } else {
                part2 = chooseOne(bookNameParts.part2.filter(b2 => !part2Numbers.includes(b2)));
                part1 = chooseOne(bookNameParts.part1.filter(b1 => b1.length <= (maxBookNameLength - part2.length)));
            }

            if (part1.endsWith("-")) {
                part1 = part1.slice(0, -1);
                part2 = part2.charAt(0).toLowerCase() + part2.slice(1);
                return `${part1}${part2}`;
            }
            return `${part1} ${part2}`;
        }

        function findSynonym(oldName) {
            const synonymData = synonyms.find(s => s.name == oldName);
            if (synonymData != undefined && synonymData.aliases.length) {
                return chooseOne([...synonymData.aliases, oldName]);
            }
            return oldName;
        }
        
        // Оновлюємо функцію для використання предметів
        function useItem(index) {
            const item = player.inventory[index];
            
            if (item.type === 'potion_attack') {
                player.baseAttack += item.bonus;
                addLog(`🧪 Ви випили ${item.emoji} ${item.name}! Ваша атака збільшилась на ${item.bonus}. (${player.baseAttack-item.bonus} => ${player.baseAttack})`, 'system');
                updateStats();
            }
            else if (item.type === 'potion_defense') {
                player.baseDefense += item.bonus;
                addLog(`🧪 Ви випили ${item.emoji} ${item.name}! Ваш захист збільшився на ${item.bonus}. (${player.baseDefense-item.bonus} => ${player.baseDefense})`, 'system');
                updateStats();
            }
            else if (item.type === 'potion_health') {
                player.bonusHealth += item.bonus;
                updateStats();
                addLog(`🧪 Ви випили ${item.emoji} ${item.name}! Ваше максимальне здоров'я збільшилось на ${item.bonus}. (${player.maxHealth-item.bonus} => ${player.maxHealth})`, 'system');

                setTimeout(() => {
                    player.health += item.bonus;
                    updateStats();
                }, 250);
            } else {
                // Якщо це не еліксир, екіпіруємо як звичайний предмет
                equipItem(index);
                return;
            }

            if (['potion_attack', 'potion_defense', 'potion_health'].includes(item.type)) {
                addPopupMessage(`${addEmojiPlayer(item.emojiType)}+${item.bonus}`, elements.playerEmoji, {
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
            let rarity = getBiasedRarity(currentMapLevel);

            // Фільтруємо артефакти і зілля за рідкістю
            let items;
            if (Math.random() < 0.5) {
                items = [...artifacts, ...potions];
            } else {
                items = [...artifacts];
            }
            
            const availableArtifacts = items.filter(item => item.rarity <= rarity);
            
            if (availableArtifacts.length === 0) return null;
            
            // Вибираємо випадковий артефакт з доступних
            let artifactTemplate = availableArtifacts[Math.floor(Math.random() * availableArtifacts.length)];
            if (Math.random() < 0.25) {
                artifactTemplate = makeItemMagic(artifactTemplate);
            }
            
            // Створюємо копію артефакта для гравця
            return {
                ...artifactTemplate,
                id: uniqueId()
            };
        }

        // Створюєм монстряку
        // diffType = 'normal' / 'elite' / 'boss'
        function generateEnemy(diffType = 'normal') {
            // Визначаємо тип ворога залежно від рівня гравця
            let enemyPool;
            if (diffType == 'boss') {
                enemyPool = enemyTypes.filter(e => e.boss);
            } else if (diffType == 'elite') {
                enemyPool = enemyTypes.filter(e => e.elite);
            } else {
                enemyPool = enemyTypes.filter(e => !e.elite && !e.boss);
            }
            
            const enemyTemplate = enemyPool[Math.floor(Math.random() * enemyPool.length)];
            const enemy = {...enemyTemplate};
            
            // Базова сила ворога залежить від рівня гравця
            const basePower = 2 + currentMapLevel;
            let powerMultiplier = 1.5;
            if (enemy.elite) powerMultiplier = 2.1;
            if (enemy.boss) powerMultiplier = 3;
            
            // Характеристики ворога
            //enemy.health = Math.floor(basePower * powerMultiplier * (0.8 + Math.random() * 0.4));
            enemy.health = Math.floor(basePower * powerMultiplier * (1.25 + Math.random() * 0.75));
            
            // Атака та захист з урахуванням здібностей
            enemy.attack = Math.floor(basePower * powerMultiplier * (0.5 + Math.random() * 0.5));
            enemy.defense = Math.floor(basePower * powerMultiplier * (0.3 + Math.random() * 0.4));
            
            // Бонуси від здібностей
            if (enemy.abilities.includes('strong')) enemy.attack += 2;
            if (enemy.abilities.includes('tough')) {
                enemy.defense += 2;
                enemy.health = Math.floor(enemy.health * 1.3);
            }

            // magic_resist - збільшує захист ворога на 1 і трохи нижче блокує 20% усього демагу - хітра жопа
            if (enemy.abilities.includes('magic_resist')) enemy.defense += 1;
            
            enemy.maxHealth = enemy.health;
            enemy.baseMaxHealth = enemy.health;
            
            // Нагороди
            enemy.gold = Math.floor(basePower * powerMultiplier * (0.5 + Math.random() * 1));
            enemy.xp = Math.floor(basePower * powerMultiplier * (0.8 + Math.random() * 1));
            
            if (enemy.elite) {
                enemy.gold = Math.floor(enemy.gold * 1.75);
                enemy.xp = Math.floor(enemy.xp * 1.75);
            }
            if (enemy.boss) {
                enemy.gold = Math.floor(enemy.gold * 3.5);
                enemy.xp = Math.floor(enemy.xp * 3.5);
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

        // функція набивання попап повідомлень
        function addPopupMessage(text, targetElement, options = {}) {
            const defaultOptions = {
                color: '#fff',
                fontSize: '24px',
                isCritical: false,
                delay: 0,  // Затримка в мілісекундах (0 - без затримки)
                popupType: 'normal', // Час існування сповіщення ('normal' - 2s, 'slow' - 4s)
                horizontalOffset: 0, // Зсув точки спавна в px
            };

            popupMessages.push({msg: text, rectPosition: targetElement.getBoundingClientRect(), options: { ...defaultOptions, ...options }});
        }

        // функція яка починає спавнити повідомленнями
        function sendPopupMessage() {
            // повідомлень вже немає
            if (popupMessages.length < 1) {
                popupSendingStatus = false;
                return;
            }

            const defaultDelay = 250;
            // відриваєм перше повідомлення зі списку
            const popupMessage = popupMessages.shift();

            // Функція, яка фактично створює і показує попап
            const createPopup = () => {
                const popupElement = document.createElement('div');
                let infoText = popupMessage.msg;

                popupElement.className = popupMessage.options.popupType == 'slow' ? 'event-popup-slow' : 'event-popup';
                
                // Застосовуємо стилі
                popupElement.style.color = popupMessage.options.color;
                popupElement.style.fontSize = popupMessage.options.fontSize;
                
                if (popupMessage.options.isCritical) {
                    infoText += addEmojiPlayer('💥');
                    popupElement.style.fontWeight = 'bold';
                    popupElement.style.textShadow = '2px 2px 3px black';//'0 0 5px gold';
                }

                popupElement.innerHTML = `<div class="popup-info">${infoText}</div>`;
                
                // Позиціонування
                const rect = popupMessage.rectPosition;
                popupElement.style.position = 'absolute';
                popupElement.style.left = `${popupMessage.options.horizontalOffset + rect.left + rect.width/2 - 20}px`;
                popupElement.style.top = `${rect.top - 20}px`;
                popupElement.style.zIndex = '1000';
                popupElement.style.pointerEvents = 'none';
                popupElement.style.animation = `popup ${(popupMessage.options.popupType == 'slow' ? 4 : 2)}s forwards`;
                
                document.body.appendChild(popupElement);
                
                // Видалення елемента після анімації
                setTimeout(() => {
                    popupElement.remove();
                }, popupMessage.options.popupType == 'slow' ? 4000 : 2000);
            };
            
            // Викликаємо створення попапу з затримкою або без
            if (popupMessage.options.delay > 0) {
                setTimeout(createPopup, popupMessage.options.delay);
            } else {
                createPopup();
            }

            setTimeout(() => {
                sendPopupMessage()
            }, defaultDelay);
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
                    addPopupMessage(`${addEmojiPlayer('💨','30px')}`, elements.enemyEmoji, {
                        color: '#f00',
                    });
                    playerDamage = 0;
                }
                
                // Хвороба знижує атаку на 75% але лише не критичні
                if (!isCritical && enemy.abilities.includes('disease') && Math.random() < 0.3) {
                    addLog(`🤢 ${enemy.emoji} ${enemy.type} послабив вашу атаку хворобою!`, 'enemy', '#124f12');
                    addPopupMessage(`${addEmojiPlayer('🤢')}`, elements.enemyEmoji, {
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
                        addPopupMessage(`-${playerDamage}`, elements.enemyEmoji, {
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
                    
                    addPopupMessage(`+${enemy.gold}${addEmojiPlayer('💰')}`, elements.playerEmoji, {
                        color: '#ff0',
                        fontSize: '20px',
                        //delay: 500,
                        horizontalOffset: -25
                    });
                    addPopupMessage(`+${enemy.xp}${addEmojiPlayer('📈')}`, elements.playerEmoji, {
                        color: '#88f',
                        fontSize: '18px',
                        //delay: 750,
                        horizontalOffset: 15
                    });
                    
                    // Перевірка на предмет
                    if (enemy.item) {
                        addLog(`🎁 ${enemy.item.emoji} Ви отримали: <strong>${enemy.item.name}</strong>!`, 'item', '#4504ed');

                        // отримуєм предмет
                        pickUpItem(enemy.item);

                        updateInventory();

                        addPopupMessage(`${addEmoji(enemy.item.emoji, '32px', enemy.item.subtype)}`, elements.playerEmoji, {
                            color: '#88f',
                            fontSize: '18px',
                            //delay: 1000,
                        });
                    }

                    // іноді ще можна підняти з ворога квиток
                    if (enemy.boss && Math.random() < 0.3 || enemy.elite && Math.random() < 0.1) {
                        addLog(`✨🎟️ Ви знайшли квиток! Використайте його для гри або у крамниці!`, 'artifact', '#4504ed');
                        player.tickets++;
                        addPopupMessage(`${addEmoji('🎟️', '32px')}`, elements.playerEmoji, {
                            fontSize: '40px',
                            //delay: (enemy.item) ? 1250 : 1000,
                            horizontalOffset: (enemy.item) ? -25 : 0
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
                        player.clearedRooms++;

                        // після зачищення кімнати даємо гравцю доступ до кімнати рівня +1
                        if (!levelsCompleted.includes(player.clearedRooms)) {
                            levelsCompleted.push(player.clearedRooms);
                        }

                        // Спавним - крамничку
                        let infoShop = '';
                        if (player.clearedRooms % 2 == 0) {
                            const newStore = chooseStore();
                                  infoShop = ` <br>На локації з'явилась ${newStore.emoji} ${newStore.name}`;
                            
                            spawnStore(newStore.type);
                        }
                        showGameMessage(`Рівень ${player.clearedRooms} зачищено!`, `🎉 Ви зачистили рівень від ворогів!${infoShop}`);

                        // робімо вихід
                        spawnExit();
                        updateMap();
                    }
                    
                    // Перевірка на новий рівень
                    checkLevelUp();
                    //addLog(`---------------`, 'enemy');
                    
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
                        addPopupMessage(`${addEmojiPlayer('💪')}`, elements.playerEmoji, {
                            color: '#fff',
                            horizontalOffset: -25
                        });
                    }
                    if (enemy.abilities.includes('fire_breath') && Math.random() < 0.25) {
                        const fireDamage = Math.max(1, Math.floor(enemyDamage * 0.5));
                        enemyDamage += fireDamage;
                        addPopupMessage(`-${fireDamage}${addEmojiPlayer('🔥')}`, elements.playerEmoji, {
                            color: '#f00',
                            delay: 250,
                            horizontalOffset: -40
                        });
                        addLog(`[${iteration}] 🔥 ${enemy.emoji} ${enemy.type} використовує вогняне дихання (+${fireDamage} шкоди)!`, 'enemy');
                    }
                    if (enemy.abilities.includes('poison') && Math.random() < 0.25) {
                        const poisonDamage = Math.max(1, Math.floor(enemyDamage * 0.3));
                        enemyDamage += poisonDamage;
                        addPopupMessage(`-${poisonDamage}${addEmojiPlayer('☣️')}`, elements.playerEmoji, {
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
                        addPopupMessage(`+${suckDamage}${addEmojiPlayer('🩸')}`, elements.enemyEmoji, {
                            color: '#f00',
                            delay: 50,
                        });
                        addLog(`[${iteration}] 🩸 ${enemy.emoji} ${enemy.type} п'є Вашу кров (-${suckDamage} життя)!`, 'enemy', '#470505');
                        updateEnemyStats(enemy);
                    }
                    
                    player.health -= enemyDamage;
                    
                    if (enemyDamage > 0) {
                        addPopupMessage(`-${enemyDamage}`, elements.playerEmoji, {
                            color: '#f00',
                        });
                    }
                    
                    animateAttack(elements.playerEmoji, elements.playerView);
                    
                    // Регенерація ворога
                    if (enemy.abilities.includes('regeneration') && Math.random() < 0.4) {
                        const healAmount = Math.floor(enemy.maxHealth * 0.1);
                        enemy.health = Math.min(enemy.maxHealth, enemy.health + healAmount);
                        addPopupMessage(`+${healAmount}${addEmojiPlayer('💚')}`, elements.enemyEmoji, {
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
                        addPopupMessage(`-${enemyDamage}`, elements.playerEmoji, {
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
                    startDeath(`💀 Ви загинули в бою з ${enemy.emoji} ${enemy.type}!`);
                    
                    // Продовжуємо бій
                    setTimeout(battleStep, 1000);
                }, fastEnemyStatus ? 0 : 1000);
            }
            
            // Починаємо бій
            battleStep();
        }

        function startDeath(message) {
            if (player.health <= 0) {
                // Показуєм кнопку відродження
                elements.resurrectBtn.style.display = 'inline-block';

                elements.playerEmoji.style.filter = `grayscale(100%)`;
                addLog(message, 'system');
                showGameMessage(`${addEmoji('💀', '25px')} Поразка`, `${message} <br>Натисніть ОК щоб продовжити гру.`, 0, 'danger', resurrect);

                addPopupMessage(`${addEmoji('💀', '40px')}`, document.getElementById('player-on-map'), {
                    fontSize: '40px',
                });

                // ховаєм карту і викидаєм гравця з карти на вибір рівнів
                spawnLevelList();

                // виходим на вибір рівнів
                player.inLevelSelection = true;
                elements.levels.style.display = 'block';
                elements.map.style.display = 'none';
                // Ховаєм кнопку гемблінга
                elements.gambleBtn.style.display = 'none';

                elements.enemyEmoji.innerHTML = addEmoji(emptyEmoji, '64px');
                elements.vs.style.visibility = 'hidden';
                elements.enemyStats.style.visibility = 'hidden';
                elements.enemyHealthBarWrapper.style.visibility = 'hidden';

                tabManager.setTab(['levels', 'inventory']);

                return;
            }
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
                        'hungry': 'Голодний: знищує харчі',
                        'ghost': 'Примара: миттєво переміщується',
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

            elements.enemyStats.innerHTML = `${attackEmoji}: ${enemyAttack}&nbsp;&nbsp;&nbsp;${defenseEmoji}: ${enemyDefense}&nbsp;&nbsp;&nbsp;${healthEmoji}: ${(enemy.health >= 0 ? enemy.health : 0)}/${enemyMaxHealth}`;
            
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

                // збільшення характеристик нова логіка
                // якщо рівень чотний збільшуєм атаку на 1 і хп на 2, якщо ні збільшує захист на 1 і хп на 3
                const oldMaxHealth = player.maxHealth;
                let levelinfo = '';
                // рівні 2/4/6/8 - дають +3хп 
                // рівні 3/5/7/9 - дають +2хп
                // розрахунок на рівні get maxHealth()
                if (player.level % 2 == 0) {
                    player.baseDefense += 1;
                    //player.health += 2;
                    levelinfo = "Ваша захист 🛡️ збільшився на 1, а Ваше 💖 здоров'я збільшилось на 3";
                } else {
                    player.baseAttack += 1;
                    //player.health += 3;
                    levelinfo = "Ваш атака ⚔️ збільшилась на 1, а Ваше 💖 здоров'я збільшилось на 2";
                }

                addLog(`🌟 Вітаємо! Ви досягли ${player.level} рівня! ${levelinfo}.`, 'system');
                addPopupMessage(`${addEmojiPlayer('🌟')} ${player.level} ${addEmojiPlayer('🌟')}`, document.getElementById('player-on-map'), {
                    color: '#ff0',
                    fontSize: '20px',
                    delay: 1000,
                    horizontalOffset: -20,
                    popupType: 'slow',
                });

                // заліковуємо рани
                player.health = player.maxHealth;

                // Додаємо фруктові клітинки при отриманні рівня
                spawnFruits();
                spawnArtifacts();
                spawnChest();

                updateStats();
                return true;
            }
            return false;
        }

        function updateGamblePrice () {
            if (player.tickets < 1) {
                elements.gamblePrice.innerHTML = `${gamblingPrice()}${addEmoji('💰', '20px', undefined, 'vertical-align: text-bottom!important; margin-left: 4px;')}`;
                elements.slotButton.classList.remove('tickets');
            } else {
                elements.gamblePrice.innerHTML = `${player.tickets}${addEmoji('🎟️', '20px', undefined, 'vertical-align: text-bottom!important; margin-left: 4px;')}`;
                elements.slotButton.classList.add('tickets');
            }
        }

        function gamblingPrice() {
            return player.level * 25;
        }

        // Лікування
        function heal() {
            if (player.gold >= 10) {
                player.gold -= 10;
                const deltaHealth = player.maxHealth - player.health;
                player.health = player.maxHealth;
                addLog('💊 Ви повністю вилікувались!', 'system');
                addPopupMessage(`+${deltaHealth}❤️`, elements.playerEmoji, {
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

        // Відродження
        function resurrect() {
            if (player.health > 0) return;

            // можем рухать
            player.isBattle = false;

            // Ховаємо кнопку Відродження
            elements.resurrectBtn.style.display = 'none';
            // Показуєм кнопку гемблінга nope
            // elements.gambleBtn.style.display = 'inline-block';
            // фокусуємось на останньому рівні
            document.querySelector(`.levels-selector[data-floor="${levelSelected}"]`).focus();

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
            
            // Вороги також відпочивають (респавняться)
            enemies = [];

            const savedData = gatherAllMapData();
            const tmpDensity = 0.45 + Math.random() * 0.15;
            regenerateMap(player.position, tmpDensity, savedData);

            // спавн фрукта після смерті трошки покращить становище в бою
            spawnFruits(1);
            spawnEnemies();
            resetTerra();

            updateStats();
            updateMap();
        }

        // кнопка оновлення цін в крамниці
        function updateStorePrices() {
            const updatePrice = player.level * 25;

            // якщо взагалі існує крамниця біля гравця
            if (player.getCurrentCell().storeType == undefined) return;

            const currentStore = getStoreHubById(player.getCurrentCell().id);

            // якщо не вистачає золота або квитків не можна оновлювати магазин
            if (player.gold < updatePrice && player.tickets < 1) {
                addLog(`💰 Ви не можете оновити асортимент крамниці адже не вистачає ${updatePrice} золота!`, 'system', 'red');
                return;
            }
            // якщо крамниця не isRefreshing false - тоне можна оновити, бо це весь асортимент
            if (!currentStore.isRefreshing) {
                addLog(`💰 Ви не можете оновити асортимент крамниці - це вcе що є у крамаря!`, 'system', 'red');
                return;
            }

            if (player.tickets > 0) {
                player.tickets--;
            } else {
                player.gold -= updatePrice;
            }

            // враховуєм тип крамниці
            generateStore(currentStoreType, currentStore.id);
            updateStore();
            updateStats();
        }

        function changeLogSize(sizeType = 'normal') {
            if (sizeType == 'small') {
                elements.log.classList.add('log-shorted');
                elements.log.scrollTop = elements.log.scrollHeight;
            } else {
                elements.log.classList.remove('log-shorted');
                elements.log.scrollTop = elements.log.scrollHeight;
            }
        }

        function toogleInventory() {
            // змінюєм статус "Гравець в інвентарі"
            player.inInventory = !player.inInventory;
            player.inStore = false;

            // відображаєм інвентар
            elements.inventory.style.display = player.inInventory ? 'block' : 'none';
            elements.store.style.display = 'none';
            // ховаєм мапу
            elements.map.style.display = player.inInventory ? 'none' : 'grid';
            if (player.inLevelSelection) elements.map.style.display = 'none';

            // ховаєм кнопку інвентаря
            //elements.inventoryBtn.style.display = player.inInventory ? 'none' : 'inline-block';
            // показуєм кнопку мапи
            //elements.mapBtn.style.display = player.inInventory ? 'inline-block' : 'none';

            //elements.log.style.display = player.inInventory ? 'none' : 'block';
            if (player.inInventory) {
                elements.log.classList.add('log-shorted');
                elements.log.scrollTop = elements.log.scrollHeight;
                if (player.inLevelSelection) {
                    elements.levels.style.display = 'none';
                }
            } else {
                elements.log.classList.remove('log-shorted');
                elements.log.scrollTop = elements.log.scrollHeight;
                if (player.inLevelSelection) {
                    elements.levels.style.display = 'block';
                }
            }
        }

        function toogleStore() {
            updateStore();
            // змінюєм статус "Гравець в крамниці"
            player.inStore = !player.inStore;
            player.inInventory = false;

            // назва
            const currentStore = storeTypes.find(e => e.type == currentStoreType);
            if (currentStore != null) elements.storeName.innerHTML = `${currentStore.emoji} ${currentStore.name} Рівень:${currentMapLevel}`;

            // відображаєм крамницю
            elements.store.style.display = player.inStore ? 'block' : 'none';
            elements.inventory.style.display = 'none';
            // ховаєм мапу
            elements.map.style.display = player.inStore ? 'none' : 'grid';

            //elements.log.style.display = player.inStore ? 'none' : 'block';
            if (player.inStore) {
                elements.log.classList.add('log-shorted');
                elements.log.scrollTop = elements.log.scrollHeight;
                if (player.inLevelSelection) {
                    elements.levels.style.display = 'none';
                }
            } else {
                elements.log.classList.remove('log-shorted');
                elements.log.scrollTop = elements.log.scrollHeight;
                if (player.inLevelSelection) {
                    elements.levels.style.display = 'block';
                }
            }
        }

        function beginAll() {
            // даєм діду паличку
            player.equipment['weapon'] = weapons[0];
            player.equipment['armor'] = armors[0];

            // Обробники подій
            elements.healBtn.addEventListener('click', heal);
            //elements.gambleBtn.addEventListener('click', gamble);
            elements.resurrectBtn.addEventListener('click', resurrect);
            elements.updateStoreBtn.addEventListener('click', updateStorePrices);

            elements.inventoryBtn.addEventListener('click', toogleInventory);
            elements.mapBtn.addEventListener('click', toogleInventory);
            elements.closeInventoryBtn.addEventListener('click', toogleInventory);

            elements.storeBtn.addEventListener('click', toogleStore);
            elements.closeStoreBtn.addEventListener('click', toogleStore);

            // Глобальні функції для виклику з HTML
            window.equipItem = equipItem;
            window.sellItem = sellItem;

            // buttons 
            document.addEventListener("keydown", (e) => {
                if (tabManager.getActiveTab() == 'map-block') {
                    if (e.code === "ArrowUp") movePlayer(player.position.x, player.position.y - 1);
                    if (e.code === "ArrowRight") movePlayer(player.position.x + 1, player.position.y);
                    if (e.code === "ArrowDown") movePlayer(player.position.x, player.position.y + 1);
                    if (e.code === "ArrowLeft") movePlayer(player.position.x - 1, player.position.y);
                } else if (tabManager.getActiveTab() == 'levels') {
                    if (e.code === "ArrowUp" || e.code === "ArrowRight") {
                        levelSelected++;
                        levelSelected = levelSelected > (levelsCompleted.length + 1) ? 0 : levelSelected;
                        document.querySelector(`.levels-selector[data-floor="${levelSelected}"]`).focus();
                    }
                    if (e.code === "ArrowDown" || e.code === "ArrowLeft") {
                        levelSelected--;
                        levelSelected = levelSelected < 0 ? (levelsCompleted.length + 1) : levelSelected;
                        document.querySelector(`.levels-selector[data-floor="${levelSelected}"]`).focus();
                    }
                }
                // gambling
                if (e.code === "KeyG") {
                    if (tabManager.getActiveTab() == 'slots' && !elements.slotButton.disabled) spinSlot();
                    else tabManager.clickTab('slots');
                };
                if (e.code === "KeyI") tabManager.clickTab('inventory');/* toogleInventory();*/
                if (e.code === "KeyS") tabManager.clickTab('store');
                if (e.code === "KeyM") tabManager.clickTab('map-block');
                if (e.code === "KeyL") tabManager.clickTab('levels');
                //if (e.code === "KeyS" && player.atStore) toogleStore();

                // resurrect
                if (e.code === "KeyR" && player.health < 1) { resurrect(); }

                // items manupulations
                if (['Digit1', 'Digit2', 'Digit3', 'Digit4', 'Digit5', 'Digit6', 'Digit7', 'Digit8' ,'Digit9'].includes(e.code)) {
                    
                    //console.log([e.code, e.shiftKey, e.altKey]);

                    const itemIndex = parseInt(e.code.split("Digit")[1]) - 1;

                    // якщо тицнем цифру із Shift - то автоматично продаєм її, але лише якщо гравець дивиться у інвентар
                    //if (e.shiftKey && player.inventory[itemIndex] != null && player.inInventory) sellItem(itemIndex);
                    if (e.shiftKey && player.inventory[itemIndex] != null && tabManager.getActiveTab() == 'inventory' && tabManager.hasTab('store')) sellItem(itemIndex);
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
            
            // Ініціалізація гри з першого рівня
            spawnLevelList();
            // initMap(1);
            
            updateStats();
            updateInventory();

            emojiReplace();

            // робимо перерахунок для всіх предметів
            recalculateAllPrices()
            //elements.enemyEmoji.innerHTML = addEmoji('👺', '64px', undefined, 'filter: grayscale(1) invert(1); opacity: 0.1;');
            elements.enemyEmoji.innerHTML = addEmoji(emptyEmoji, '64px');
            elements.vs.style.visibility = 'hidden';
            elements.enemyStats.style.visibility = 'hidden';
            elements.enemyHealthBarWrapper.style.visibility = 'hidden';

            tabManager.setTab(['levels', 'inventory']);
        }

        // спам повідомленнь
        function mainLoop() {
            // якщо повідомлення в наявності і статус того, що функція відправки вже не працює
            if (popupMessages.length > 0 && !popupSendingStatus) {
                popupSendingStatus = true;
                sendPopupMessage();
            }

            requestAnimationFrame(mainLoop);
        }

        let levelSelected = 1;
        mainLoop();

        function getInventoryCount () {
            return player.inventory.length;
        }

        function getPlayerTicketsCount () {
            return player.tickets;
        }

        function getStoreItemsCount () {
            const playerCell = player.getCurrentCell();
            if (playerCell.storeType != undefined) {
                return getStoreHubById(playerCell.id).listOfGoods.length;
            }
            return 0;
        }

        function drawTabsInfo() {
            document.querySelectorAll('.tab-counter').forEach((el) => {
                let tabIdent = el.id.replace(/^tab-/, '').replace(/-counter$/, '');
                const tabInfo = tabsInfo.find(t => t.ident == tabIdent);

                let numberData = 0;
                if (tabInfo.counterFunc != undefined) {
                    numberData = tabInfo.counterFunc();
                    el.innerHTML = numberData;
                    el.style.display = 'block';
                }

                if (numberData == 0) {
                    el.style.display = 'none';
                }
            });
        }

        // таби
        const tabsInfo = [
            { ident: 'levels',      name: 'Рівні',    emoji: '🌐', keyCode: 'L'},
            { ident: 'map-block',   name: 'Карта',    emoji: '🗺️', keyCode: 'M'},
            { ident: 'inventory',   name: 'Інвентар', emoji: '🎒', keyCode: 'I', funcs: [updateInventory],   counterFunc: getInventoryCount},
            { ident: 'store',       name: 'Крамниця', emoji: '🏬', keyCode: 'S', funcs: [updateStore],       counterFunc: getStoreItemsCount},
            { ident: 'slots',       name: 'Гемблінг', emoji: '🎰', keyCode: 'G', funcs: [updateGamblePrice], counterFunc: getPlayerTicketsCount},
        ];

        const tabManager = (() => {
            let tabsContainer = document.getElementById('tabs');
            let tabs = []; // список табів { name, button }

            function renderTabs() {
                tabsContainer.innerHTML = '';
                tabs.forEach(tab => tabsContainer.appendChild(tab.button));

                drawTabsInfo();
            }

            function setActiveTab(ident) {
                tabs.forEach(tab => {
                    const isActive = tab.ident === ident;
                    tab.button.classList.toggle('active', isActive);
                    tab.active = isActive;

                    const panel = document.getElementById(tab.ident);
                    if (panel) {
                        panel.style.display = isActive ? 'block' : 'none';
                    }

                    if (isActive) {
                        const tabInfo = {...tabsInfo.find(t => t.ident == ident)};
                        if (tabInfo.funcs != undefined) {
                            tabInfo.funcs.forEach(func => func());
                        }
                    }
                });

                if (['inventory', 'store'].includes(ident)) {
                    changeLogSize('small');
                } else {
                    changeLogSize();
                }
                drawTabsInfo();
            }

            function getActiveTab() {
                return tabs.find(t => t.active).ident;
            }

            function hasTab(ident) {
                return tabs.find(t => t.ident == ident) != undefined;
            }

            function clickTab(ident) {
                if (tabs.find(t => t.ident == ident)) {
                    tabs.find(t => t.ident == ident).button.click();
                }
            }

            function addTab(ident) {
                if (tabs.some(t => t.ident === ident)) return;

                const panel = document.getElementById(ident);
                if (!panel) return;

                const button = document.createElement('button');
                const tabInfo = tabsInfo.find(t => t.ident == ident);
                const counter = (tabInfo.counterFunc != undefined) ? tabInfo.counterFunc() : 0;

                button.innerHTML = `<span style="display:none" class="tab-counter" id="tab-${ident}-counter">${counter}</span>${addEmoji(tabInfo.emoji, '32px')}<span class="tab-desc"> ${tabInfo.name} [${tabInfo.keyCode}]</span>`;
                button.title = tabInfo.name;
                button.dataset.tab = ident;
                button.addEventListener('click', () => setActiveTab(ident));

                tabs.push({ ident, button, active: false });
                renderTabs();

                if (tabs.length === 1) setActiveTab(ident);
            }

            function removeTab(ident) {
                const index = tabs.findIndex(t => t.ident === ident);
                if (index === -1) return;

                tabs[index].button.remove();
                tabs.splice(index, 1);
                renderTabs();

                if (tabs[0]) setActiveTab(tabs[0].ident);
            }

            function setTab(idents = []) {
                tabs.forEach(t => t.button.remove());
                tabs = [];
                renderTabs();
                idents.forEach(addTab);
            }

            return {
                getActiveTab,
                hasTab,
                clickTab,
                addTab,
                removeTab,
                setTab
            };
        })();

        function logCaller() {
            return new Error().stack.split('\n')[2].match(/at (\w+)/)?.[1];
        }
    </script>
    {/ignore}