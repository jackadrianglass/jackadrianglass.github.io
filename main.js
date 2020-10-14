window.onload = main;
var TileState;
(function (TileState) {
    TileState["Hidden"] = "Hidden";
    TileState["Flagged"] = "Flagged";
    TileState["Revealed"] = "Revealed";
})(TileState || (TileState = {}));
var Tile = /** @class */ (function () {
    function Tile() {
        this.state = TileState.Hidden;
        this.numAdjMines = 0;
    }
    Tile.prototype.isMine = function () {
        return this.numAdjMines === -1;
    };
    Tile.prototype.setAsMine = function () {
        this.numAdjMines = -1;
    };
    Tile.prototype.adjMines = function () {
        return this.numAdjMines;
    };
    Tile.prototype.setNumAdjMines = function (numMines) {
        if (this.numAdjMines !== -1) {
            this.numAdjMines = numMines;
        }
    };
    Tile.prototype.getState = function () {
        if (this.state === TileState.Flagged) {
            return "F";
        }
        if (this.state === TileState.Hidden) {
            return "H";
        }
        if (this.isMine()) {
            return "M";
        }
        if (this.numAdjMines === 0) {
            return " ";
        }
        return String(this.numAdjMines);
    };
    Tile.prototype.reveal = function () {
        if (this.state !== TileState.Flagged) {
            this.state = TileState.Revealed;
        }
    };
    Tile.prototype.toggleFlag = function () {
        switch (this.state) {
            case TileState.Flagged:
                this.state = TileState.Hidden;
                break;
            case TileState.Hidden:
                this.state = TileState.Flagged;
                break;
            case TileState.Revealed:
                //Do nothing
                break;
        }
    };
    return Tile;
}());
var Pos = /** @class */ (function () {
    function Pos(row, col) {
        this.row = row;
        this.col = col;
    }
    return Pos;
}());
function create2dArray(numRows, numCols) {
    var result = [];
    for (var row = 0; row < numRows; row++) {
        result[row] = [];
        for (var col = 0; col < numCols; col++) {
            result[row][col] = new Tile();
        }
    }
    return result;
}
function getRandInt(maxVal) {
    return Math.floor(Math.random() * Math.floor(maxVal));
}
var GameState;
(function (GameState) {
    GameState[GameState["Running"] = 0] = "Running";
    GameState[GameState["Lost"] = 1] = "Lost";
    GameState[GameState["Won"] = 2] = "Won";
})(GameState || (GameState = {}));
var Game = /** @class */ (function () {
    function Game() {
    }
    Game.prototype.rows = function () { return this._rows; };
    Game.prototype.cols = function () { return this._cols; };
    Game.prototype.isPopulated = function () { return this._isPopulated; };
    Game.prototype.gameState = function () { return this._gameState; };
    Game.prototype.init = function (rows, cols, numMines) {
        this._rows = rows;
        this._cols = cols;
        this._numMines = numMines;
        this._field = create2dArray(this._rows, this._cols);
        this._isPopulated = false;
        this._gameState = GameState.Running;
        this._tilesRevealed = 0;
    };
    Game.prototype.reset = function () {
        this.init(this._rows, this._cols, this._numMines);
    };
    Game.prototype.validateCoord = function (row, col) {
        return row >= 0 && row < this._rows && col >= 0 && col < this._cols;
    };
    Game.prototype.populateMines = function (blankPos) {
        var minesPopulated = 0;
        while (minesPopulated < this._numMines) {
            var pos = new Pos(getRandInt(this._rows), getRandInt(this._cols));
            // Check if we can put a mine here
            var valid = true;
            for (var _i = 0, blankPos_1 = blankPos; _i < blankPos_1.length; _i++) {
                var tmp = blankPos_1[_i];
                if (tmp.col === pos.col && tmp.row === pos.row) {
                    valid = false;
                    break;
                }
            }
            if (!valid) {
                continue;
            }
            this._field[pos.row][pos.col].setAsMine();
            blankPos.push(pos);
            minesPopulated++;
        }
        for (var row = 0; row < this._rows; row++) {
            for (var col = 0; col < this._cols; col++) {
                this.countAdjMines({ row: row, col: col });
            }
        }
        this._isPopulated = true;
    };
    /*
    Returns an array of string values f what to render
    H = hidden
    M = Mine
    F = flagged
    " " = No adjacent mine
    "number" = Number of mines adjacent
     */
    Game.prototype.getTileArray = function () {
        var result = [];
        for (var row = 0; row < this._rows; row++) {
            for (var col = 0; col < this._cols; col++) {
                var state = this._field[row][col].getState();
                result.push(state);
            }
        }
        return result;
    };
    Game.prototype.flag = function (row, col) {
        if (this._gameState !== GameState.Running)
            return;
        this._field[row][col].toggleFlag();
    };
    Game.prototype.reveal = function (row, col) {
        var _this = this;
        if (this._gameState !== GameState.Running ||
            this._field[row][col].getState() === "F")
            return;
        var _reveal = function (row, col) {
            if (!_this.validateCoord(row, col)
                || _this._field[row][col].getState() !== "H")
                return;
            _this._field[row][col].reveal();
            _this._tilesRevealed++;
            if (_this._field[row][col].adjMines() !== 0)
                return;
            for (var i = -1; i <= 1; i++) {
                for (var j = -1; j <= 1; j++) {
                    if (i === 0 && j === 0)
                        continue;
                    _reveal(row + i, col + j);
                }
            }
        };
        _reveal(row, col);
        if (this._field[row][col].isMine()) {
            this._gameState = GameState.Lost;
            for (var _i = 0, _a = this._field; _i < _a.length; _i++) {
                var row_2 = _a[_i];
                for (var _b = 0, row_1 = row_2; _b < row_1.length; _b++) {
                    var tile = row_1[_b];
                    if (tile.isMine() && tile.getState() !== "F") {
                        tile.reveal();
                    }
                }
            }
        }
        else if (this._tilesRevealed == this._rows * this._cols - this._numMines) {
            this._gameState = GameState.Won;
        }
    };
    Game.prototype.countAdjMines = function (pos) {
        var numMines = 0;
        for (var i = -1; i < 2; i++) {
            for (var j = -1; j < 2; j++) {
                var row = pos.row + i;
                var col = pos.col + j;
                if (this.validateCoord(row, col) && this._field[row][col].isMine()) {
                    numMines++;
                }
            }
        }
        this._field[pos.row][pos.col].setNumAdjMines(numMines);
    };
    return Game;
}());
function button_callback(state, rows, cols, mines) {
    state.init(rows, cols, mines);
    render(state);
}
// Declared global because typescript doesn't have static
// local variables :'(
var timerId; //used for the game time metric
var runTime = 0;
function card_click_callback(state, card, idx) {
    var row = Math.floor(idx / state.cols());
    var col = Math.floor(idx % state.cols());
    if (!state.isPopulated()) {
        var noMines = [];
        for (var i = -1; i < 2; i++) {
            for (var j = -1; j < 2; j++) {
                if (state.validateCoord(row + i, col + j)) {
                    noMines.push(new Pos(row + i, col + j));
                }
            }
        }
        state.populateMines(noMines);
        //start the timer
        timerId = setInterval(function () {
            runTime++;
            document.querySelectorAll(".time").forEach(function (span) {
                span.innerHTML = String(runTime);
            });
        }, 1000);
    }
    state.reveal(row, col);
    render(state);
    if (state.gameState() !== GameState.Running) {
        clearInterval(timerId);
        var gameOverStr = void 0;
        if (state.gameState() === GameState.Lost) {
            gameOverStr = "BOOOOM! You hit a mine!";
        }
        else {
            gameOverStr = "Congrats! You found all the mines!";
        }
        document.querySelector("#gameStatus").innerHTML = gameOverStr;
        document.querySelector("#overlay").classList.toggle("active");
        //clear runtime
        runTime = 0;
    }
}
function render(state) {
    var grid = document.querySelector(".grid");
    grid.style.gridTemplateColumns = "repeat(" + state.cols() + ", 1fr)";
    var maxIdxVal = state.rows() * state.cols();
    var renderValues = state.getTileArray();
    var _loop_1 = function (i) {
        var card = grid.children[i];
        var ind = Number(card.getAttribute("data-cardIdx"));
        if (ind >= maxIdxVal) {
            card.style.display = "none";
        }
        else {
            card.style.display = "block";
            var classes_1 = ["revealed", "one", "two", "three",
                "four", "five", "six", "seven", "eight", "flag", "mine"];
            var removeExcept = function (classList) {
                for (var _i = 0, classes_2 = classes_1; _i < classes_2.length; _i++) {
                    var cls = classes_2[_i];
                    if (classList.indexOf(cls) !== -1)
                        continue;
                    card.classList.remove(cls);
                }
            };
            card.classList.remove("flagged", "revealed");
            switch (renderValues[ind]) {
                case "H":
                    removeExcept([]);
                    card.style.color = "black";
                    card.innerText = " ";
                    break;
                case "M":
                    removeExcept(["revealed", "mine"]);
                    card.classList.add("revealed", "mine");
                    break;
                case "F":
                    removeExcept(["flagged"]);
                    card.classList.add("flagged");
                    card.style.backgroundImage;
                    break;
                case " ":
                    removeExcept(["revealed"]);
                    card.classList.add("revealed");
                    break;
                case "1":
                    removeExcept(["revealed", "one"]);
                    card.classList.add("revealed", "one");
                    break;
                case "2":
                    removeExcept(["revealed", "two"]);
                    card.classList.add("revealed", "two");
                    break;
                case "3":
                    removeExcept(["revealed", "three"]);
                    card.classList.add("revealed", "three");
                    break;
                case "4":
                    removeExcept(["revealed", "four"]);
                    card.classList.add("revealed", "four");
                    break;
                case "5":
                    removeExcept(["revealed", "five"]);
                    card.classList.add("revealed", "five");
                    break;
                case "6":
                    removeExcept(["revealed", "six"]);
                    card.classList.add("revealed", "six");
                    break;
                case "7":
                    removeExcept(["revealed", "seven"]);
                    card.classList.add("revealed", "seven");
                    break;
                case "8":
                    removeExcept(["revealed", "eight"]);
                    card.classList.add("revealed", "eight");
                    break;
            }
        }
    };
    for (var i = 0; i < grid.children.length; i++) {
        _loop_1(i);
    }
}
function flag(state, idx) {
    var row = Math.floor(idx / state.cols());
    var col = Math.floor(idx % state.cols());
    state.flag(row, col);
    render(state);
}
var pressTimer;
function prepare_dom(state) {
    var grid = document.querySelector(".grid");
    var nCards = 20 * 24; // max size
    var _loop_2 = function (i) {
        var card = document.createElement("div");
        card.className = "card";
        card.style.display = "none";
        card.setAttribute("data-cardIdx", String(i));
        card.addEventListener("mousedown", function (event) {
            if (event.button === 2) {
                flag(state, i);
            }
            else {
                pressTimer = setTimeout(function () {
                    flag(state, i);
                }, 1000);
            }
        });
        card.addEventListener("mouseup", function () {
            clearTimeout(pressTimer);
            card_click_callback(state, card, i);
        });
        card.addEventListener("contextmenu", function (event) {
            event.preventDefault();
        }, false);
        grid.appendChild(card);
    };
    for (var i = 0; i < nCards; i++) {
        _loop_2(i);
    }
}
function main() {
    var state = new Game();
    document.querySelectorAll(".menuButton").forEach(function (button) {
        var _a = button.getAttribute("data-size").split("x").map(function (s) { return Number(s); }), rows = _a[0], cols = _a[1], mines = _a[2];
        button.addEventListener("click", button_callback.bind(null, state, rows, cols, mines));
    });
    document.querySelector("#overlay").addEventListener("click", function () {
        document.querySelector("#overlay").classList.remove("active");
        document.querySelectorAll(".time").forEach(function (span) {
            span.innerHTML = String(runTime);
        });
        state.reset();
        render(state);
    });
    prepare_dom(state);
    button_callback(state, 8, 10, 10);
}
