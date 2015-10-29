

module Ling.Fmt.Albert.Abs where

-- Haskell module generated by the BNF converter




newtype Name = Name String deriving (Eq, Ord, Show, Read)
data Program = Prg [Dec]
  deriving (Eq, Ord, Show, Read)

data Dec
    = DPrc Name [ChanDec] Proc OptDot
    | DDef Name OptSig TermProc OptDot
    | DSig Name Term OptDot
    | DDat Name [ConName] OptDot
    | DAsr Assertion
  deriving (Eq, Ord, Show, Read)

data Assertion = AEq Term Term Term
  deriving (Eq, Ord, Show, Read)

data ConName = CN Name
  deriving (Eq, Ord, Show, Read)

data OptDot = NoDot | SoDot
  deriving (Eq, Ord, Show, Read)

data TermProc = SoTerm Term | SoProc Proc
  deriving (Eq, Ord, Show, Read)

data OptSig = NoSig | SoSig Term
  deriving (Eq, Ord, Show, Read)

data VarDec = VD Name Term
  deriving (Eq, Ord, Show, Read)

data VarsDec = VsD Name [Name] Term
  deriving (Eq, Ord, Show, Read)

data ChanDec = CD Name OptSession
  deriving (Eq, Ord, Show, Read)

data Branch = Br ConName Term
  deriving (Eq, Ord, Show, Read)

data Literal
    = LInteger Integer | LDouble Double | LString String | LChar Char
  deriving (Eq, Ord, Show, Read)

data ATerm
    = Var Name
    | Lit Literal
    | Con ConName
    | TTyp
    | TProto [RSession]
    | Paren Term
    | End
    | Par [RSession]
    | Ten [RSession]
    | Seq [RSession]
  deriving (Eq, Ord, Show, Read)

data DTerm = DTTyp Name [ATerm] | DTBnd Name Term
  deriving (Eq, Ord, Show, Read)

data Term
    = RawApp ATerm [ATerm]
    | Case Term [Branch]
    | Snd DTerm CSession
    | Rcv DTerm CSession
    | Dual Term
    | Loli Term Term
    | TFun VarsDec [VarsDec] Term
    | TSig VarsDec [VarsDec] Term
    | Lam VarsDec [VarsDec] Term
    | TProc [ChanDec] Proc
  deriving (Eq, Ord, Show, Read)

data Proc
    = PAct Act | PPrll [Proc] | PNxt Proc Proc | PDot Proc Proc
  deriving (Eq, Ord, Show, Read)

data Act
    = Nu ChanDec ChanDec
    | ParSplit Name [ChanDec]
    | TenSplit Name [ChanDec]
    | SeqSplit Name [ChanDec]
    | Send Name ATerm
    | Recv Name VarDec
    | NewSlice [ChanDec] ATerm Name
    | Ax ASession [ChanDec]
    | SplitAx Integer ASession Name
    | At ATerm TopCPatt
  deriving (Eq, Ord, Show, Read)

data ASession = AS ATerm
  deriving (Eq, Ord, Show, Read)

data TopCPatt
    = OldTopPatt [ChanDec]
    | ParTopPatt [CPatt]
    | TenTopPatt [CPatt]
    | SeqTopPatt [CPatt]
  deriving (Eq, Ord, Show, Read)

data CPatt
    = ChaPatt ChanDec
    | ParPatt [CPatt]
    | TenPatt [CPatt]
    | SeqPatt [CPatt]
  deriving (Eq, Ord, Show, Read)

data OptSession = NoSession | SoSession RSession
  deriving (Eq, Ord, Show, Read)

data RSession = Repl Term OptRepl
  deriving (Eq, Ord, Show, Read)

data OptRepl = One | Some ATerm
  deriving (Eq, Ord, Show, Read)

data CSession = Cont Term | Done
  deriving (Eq, Ord, Show, Read)

