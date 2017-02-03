/**
 A very rough tokeniser/parser in Swift for a single statement
 */

import Cocoa

let inputString = "Move the picture1 up 10 pixels"  //Good syntax
//let inputString = "Move something picture1 up 10 pixels"  //Bad syntax
//let inputString = "Move pixels picture1 up 10 pixels"  //Bad syntax wrong token


// Grammar supported
enum Grammar {
    case MOVE
    case THE
    case ID
    case UP
    case VALUE
    case MEASUREMENT
}
// string <-> Grammar map
let symbols = [
    ("Move", .MOVE),
    ("the", .THE),
    ("up", .UP),
    ("pixels", Grammar.MEASUREMENT)]

// Symbol storage
var symbolTable:[(symbol:String, e:Grammar)] = []

// storage for tokens
var tokenTable:[(symbol:String, count:Int, grammar:Grammar)] = []

// A pointer to where we are in the token list
var tokenPointer = 0


/**
 Works out what type of token a string is.
 */
func getType(item:String) -> Grammar
{
    for x in symbols
    {
        if item == x.0
        {
            return x.1
        }
    }
    return .ID
}

/**
 Takes an input string and splits it up into tokens
 */
func tokenize(input:String)
{
    var look = ""
    for char in input.characters
    {
        //Read until space is found
        if char == " "
        {
            if let _ = Int(look)
            {
                let t = (symbol:look, count:1, grammar: Grammar.VALUE)
                tokenTable.append(t)
            } else {
                let type = getType(item: look)
                let t = (symbol:look, count:1, grammar: type)
                tokenTable.append(t)
            }

            look = ""
            
        } else {
            look = look + String(char)
        }
    }
}

/**
 Specialist handler of parsing the MOVE statement
 */
func handleMove(x:Grammar)
{
    // Next token should be either an ID, or THE
    tokenPointer += 1
    var currentToken = tokenTable[tokenPointer]
    //print("currentToken 1: \(currentToken)")
    if currentToken.grammar == .THE {
        // skip
    } else if currentToken.grammar == .ID {
        tokenPointer -= 1
    } else {
        print("compiler error: Wrong token after MOVE")
    }
    
    tokenPointer += 1
    currentToken = tokenTable[tokenPointer]
    //print("currentToken 2: \(currentToken)")
    if currentToken.grammar != .ID {
        print("compiler error: MOVE [ID|THE] missing")
    }

    // Next token should be .DIRECTION
    tokenPointer += 1
    currentToken = tokenTable[tokenPointer]
    //print("currentToken 3: \(currentToken)")
    if currentToken.grammar != .UP {
        print("compiler error: MOVE [ID|THE] [DIRECTION] missing")
    }
    
    // Next token should be .VALUE
    tokenPointer += 1
    currentToken = tokenTable[tokenPointer]
    //print("currentToken 4: \(currentToken)")
    if currentToken.grammar != .VALUE {
        print("compiler error: MOVE [ID|THE] [DIRECTION] [VALUE] missing")
    }
}

/**
 Iterate of the tokens and check for validity
 */
func parseTokens()
{
    for tokenPointer in 0..<tokenTable.count
    {
        let currentToken = tokenTable[tokenPointer]
        switch currentToken
        {
        case let (_,_,x) where x == .MOVE:
            handleMove(x: x)
            break
        default:
            break
        }
    }
}

tokenize(input: inputString)
parseTokens()


print(tokenTable)
