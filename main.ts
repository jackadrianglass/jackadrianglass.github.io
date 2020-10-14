window.onload = main;

enum TileState {
    Hidden = "Hidden",
    Flagged = "Flagged",
    Revealed = "Revealed"
}

class Tile {
    private state: TileState
    private numAdjMines: number;

    constructor() {
        this.state = TileState.Hidden;
        this.numAdjMines = 0;
    }

    public isMine(){
        return this.numAdjMines === -1;
    }

    public setAsMine(){
        this.numAdjMines = -1;
    }

    public adjMines() {
        return this.numAdjMines;
    }

    public setNumAdjMines(numMines: number){
        if(this.numAdjMines !== -1){
            this.numAdjMines = numMines;
        }
    }

    public getState(){
        if(this.state === TileState.Flagged){
            return "F";
        }
        if(this.state === TileState.Hidden){
            return "H";
        }
        if(this.isMine()){
            return "M";
        }
        if(this.numAdjMines === 0){
            return " "
        }
        return String(this.numAdjMines);

    }

    public reveal(){
        if(this.state !== TileState.Flagged){
            this.state = TileState.Revealed;
        }
    }

    public toggleFlag(){
        switch(this.state){
            case TileState.Flagged:
                this.state = TileState.Hidden;
                numMines++;
                break;
            case TileState.Hidden:
                this.state = TileState.Flagged;
                numMines--;
                break;
            case TileState.Revealed:
                //Do nothing
                break;
        }
    }
}

class Pos {
    public row;
    public col;
    constructor(row: number, col: number) {
        this.row = row;
        this.col = col;
    }
}

function create2dArray(numRows: number, numCols: number): Tile[][]{
    const result:Tile[][] = [];
    for(let row = 0; row < numRows; row++){
        result[row] = [];
        for(let col = 0; col < numCols; col++){
            result[row][col] = new Tile();
        }
    }
    return result;
}


function getRandInt(maxVal: number): number{
    return Math.floor(Math.random() * Math.floor(maxVal));
}

enum GameState {
    Running,
    Lost,
    Won
}

class Game{
    private _rows: number;
    private _cols: number;
    private _numMines: number;
    private _tilesRevealed: number;
    private _field: Tile[][];
    private _isPopulated: boolean;
    private _gameState: GameState;

    public rows() {return this._rows;}
    public cols() {return this._cols;}
    public isPopulated() {return this._isPopulated;}
    public gameState() {return this._gameState;}

    public constructor() {
    }

    public init(rows: number, cols: number, mines: number) {
        this._rows = rows;
        this._cols = cols;
        this._numMines = mines;
        this._field = create2dArray(this._rows, this._cols);
        this._isPopulated = false;
        this._gameState = GameState.Running;
        this._tilesRevealed = 0;

        numMines = mines;
        document.querySelector(".mineCount").innerHTML = String(mines);
    }

    public reset() {
        this.init(this._rows, this._cols, this._numMines);
    }

    public validateCoord(row: number, col: number): boolean{
        return row >= 0 && row < this._rows && col >= 0 && col < this._cols;
    }

    public populateMines(blankPos: Pos[]) {
        let minesPopulated = 0;
        while(minesPopulated < this._numMines){
            const pos = new Pos(getRandInt(this._rows), getRandInt(this._cols));

            // Check if we can put a mine here
            let valid = true;
            for(let tmp of blankPos){
                if(tmp.col === pos.col && tmp.row === pos.row){
                    valid = false;
                    break;
                }
            }
            if(!valid){continue;}

            this._field[pos.row][pos.col].setAsMine();
            blankPos.push(pos);
            minesPopulated++;
        }

        for(let row = 0; row < this._rows; row++){
            for(let col = 0; col < this._cols; col++){
                this.countAdjMines({row, col});
            }
        }
        this._isPopulated = true;
    }

    /*
    Returns an array of string values f what to render
    H = hidden
    M = Mine
    F = flagged
    " " = No adjacent mine
    "number" = Number of mines adjacent
     */
    public getTileArray(){
        let result: string[] = [];
        for(let row = 0; row < this._rows; row++){
            for(let col = 0; col < this._cols; col++){
                const state = this._field[row][col].getState();
                result.push(state);
            }
        }
        return result;
    }

    public flag(row: number, col: number){
        if(this._gameState !== GameState.Running) return;

        this._field[row][col].toggleFlag();
    }

    public reveal(row: number, col: number) {
        if (this._gameState !== GameState.Running ||
            this._field[row][col].getState() === "F") return;

        const _reveal = (row, col) => {
            if(!this.validateCoord(row, col)
                || this._field[row][col].getState() !== "H") return;

            this._field[row][col].reveal();
            this._tilesRevealed++;

            if(this._field[row][col].adjMines() !== 0) return;

            for (let i = -1; i <= 1; i++) {
                for (let j = -1; j <= 1; j++) {
                    if(i === 0 && j === 0) continue;
                    _reveal(row + i, col + j);
                }
            }
        }

        _reveal(row, col);

        if (this._field[row][col].isMine()) {
            this._gameState = GameState.Lost;
            for(let row of this._field){
                for(let tile of row){
                    if(tile.isMine() && tile.getState() !== "F") {
                        tile.reveal();
                    }
                }
            }
        }
        else if (this._tilesRevealed == this._rows * this._cols - this._numMines){
            this._gameState = GameState.Won;
        }
    }

    private countAdjMines(pos: Pos){
        let numMines = 0;
        for(let i = -1; i < 2; i++){
            for(let j = -1; j < 2; j++){
                const row = pos.row + i;
                const col = pos.col + j;
                if(this.validateCoord(row, col) && this._field[row][col].isMine()){
                    numMines++;
                }
            }
        }
        this._field[pos.row][pos.col].setNumAdjMines(numMines);
    }
}

function button_callback(state: Game, rows: number, cols: number, mines: number){
    state.init(rows, cols, mines);

    render(state);
}

// Declared global because typescript doesn't have static
// local variables :'(
let timerId: number; //used for the game time metric
let runTime: number = 0;

function card_click_callback(state: Game, card: HTMLElement, idx: number){
    const row = Math.floor(idx / state.cols());
    const col = Math.floor(idx % state.cols());

    if(!state.isPopulated()){
        let noMines = [];
        for(let i = -1; i < 2; i++){
            for(let j = -1; j < 2; j++){
                if(state.validateCoord(row + i, col + j)){
                    noMines.push(new Pos(row + i, col + j));
                }
            }
        }
        state.populateMines(noMines);
        //start the timer
        timerId = setInterval(() => {
            runTime++;
            document.querySelectorAll(".time").forEach((span) => {
                span.innerHTML = String(runTime);
            })
        }, 1000);
    }
    state.reveal(row, col);

    render(state);
    if(state.gameState() !== GameState.Running){
        clearInterval(timerId);
        let gameOverStr: string;
        if(state.gameState() === GameState.Lost){
            gameOverStr = "BOOOOM! You hit a mine!";
        } else {
            gameOverStr = "Congrats! You found all the mines!";
        }
        document.querySelector("#gameStatus").innerHTML = gameOverStr;
        document.querySelector("#overlay").classList.toggle("active");

        //clear runtime
        runTime = 0;
    }
}

function render(state: Game){
    const grid = document.querySelector(".grid") as HTMLElement;
    grid.style.gridTemplateColumns = `repeat(${state.cols()}, 1fr)`;

    const maxIdxVal = state.rows() * state.cols();
    const renderValues = state.getTileArray();

    for(let i = 0; i < grid.children.length; i++){
        const card = grid.children[i] as HTMLElement;
        const ind = Number(card.getAttribute("data-cardIdx"));
        if(ind >= maxIdxVal){
            card.style.display = "none";
        }
        else {
            card.style.display = "block";
            const classes = ["revealed", "one", "two", "three",
            "four", "five", "six", "seven", "eight", "flag", "mine"];

            const removeExcept = (classList: string[]) =>{
                for(let cls of classes){
                    if(classList.indexOf(cls) !== -1) continue;
                    card.classList.remove(cls);
                }

            }
            card.classList.remove("flagged", "revealed")
            switch (renderValues[ind]){
                case "H":
                    removeExcept([]);
                    card.style.color = "black";
                    card.innerText = " "
                    break;
                case "M":
                    removeExcept(["revealed", "mine"]);
                    card.classList.add("revealed", "mine");
                    break;
                case "F":
                    removeExcept(["flagged"]);
                    card.classList.add("flagged");
                    card.style.backgroundImage
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

    }

}

let numMines = 0;
function flag(state: Game, idx:number) {
    const row = Math.floor(idx / state.cols());
    const col = Math.floor(idx % state.cols());
    state.flag(row, col);
    document.querySelector(".mineCount").innerHTML = String(numMines);
    render(state);
}

let pressTimer: number;
function prepare_dom(state:Game){
    const grid = document.querySelector(".grid");
    const nCards = 20*24; // max size
    for(let i = 0; i < nCards; i++){
        const card = document.createElement("div");
        card.className = "card";
        card.style.display = "none";
        card.setAttribute("data-cardIdx", String(i));

        const mouseDown = (event) => {
            if(event.button === 2){
                flag(state, i);
            } else {
                pressTimer = setTimeout(() => {
                    flag(state, i);
                }, 1000);
            }
            event.preventDefault();
        };
        const mouseUp = (event) => {
            clearTimeout(pressTimer);
            card_click_callback(state, card, i);
            event.preventDefault();
        };

        card.addEventListener("touchstart", mouseDown);
        card.addEventListener("touchend", mouseUp);
        card.addEventListener("mousedown", mouseDown);
        card.addEventListener("mouseup", mouseUp);

        card.addEventListener("contextmenu", event => {
            event.preventDefault();
        }, false);
        grid.appendChild(card);
    }
}

function main(){
    let state = new Game();

    document.querySelectorAll(".menuButton").forEach((button) => {
        const [rows, cols, mines] = button.getAttribute("data-size").split("x").map(s=>Number(s));
        button.addEventListener("click", button_callback.bind(null, state, rows, cols, mines))
    });

    document.querySelector("#overlay").addEventListener("click", () => {
        document.querySelector("#overlay").classList.remove("active");
        document.querySelectorAll(".time").forEach((span) => {
            span.innerHTML = String(runTime);
        });
        state.reset();
        render(state);
    })

    prepare_dom(state);
    button_callback(state, 8, 10, 10);
}