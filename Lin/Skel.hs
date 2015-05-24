module Lin.Skel where

-- Haskell module generated by the BNF converter

import Lin.Abs
import Lin.ErrM
type Result = Err String

failure :: Show a => a -> Result
failure x = Bad $ "Undefined case: " ++ show x

transName :: Name -> Result
transName x = case x of
  Name str  -> failure x


transProgram :: Program -> Result
transProgram x = case x of
  Program decs  -> failure x


transDec :: Dec -> Result
transDec x = case x of
  Dec name optchandecs proc  -> failure x
  Sig name term  -> failure x


transVarDec :: VarDec -> Result
transVarDec x = case x of
  VarDec name term  -> failure x


transOptChanDecs :: OptChanDecs -> Result
transOptChanDecs x = case x of
  NoChanDecs  -> failure x
  SoChanDecs chandecs  -> failure x


transChanDec :: ChanDec -> Result
transChanDec x = case x of
  ChanDec name optsession  -> failure x


transOp :: Op -> Result
transOp x = case x of
  Plus  -> failure x


transTerm :: Term -> Result
transTerm x = case x of
  Var name  -> failure x
  Lit n  -> failure x
  EAnn term1 term2  -> failure x
  TTyp  -> failure x
  TProto rsessions  -> failure x
  Def name terms  -> failure x
  Infix term1 op2 term3  -> failure x
  TFun vardec vardecs term  -> failure x
  TSig vardec vardecs term  -> failure x
  Proc chandecs proc  -> failure x


transProc :: Proc -> Result
transProc x = case x of
  Act prefs procs  -> failure x


transProcs :: Procs -> Result
transProcs x = case x of
  ZeroP  -> failure x
  Ax session name1 name2 snks3  -> failure x
  At term names  -> failure x
  Procs procs  -> failure x


transSnk :: Snk -> Result
transSnk x = case x of
  Snk name  -> failure x


transPref :: Pref -> Result
transPref x = case x of
  Nu chandec1 chandec2  -> failure x
  ParSplit name chandecs  -> failure x
  TenSplit name chandecs  -> failure x
  NewSlice term name  -> failure x
  Send name term  -> failure x
  Recv name vardec  -> failure x


transOptSession :: OptSession -> Result
transOptSession x = case x of
  NoSession  -> failure x
  SoSession session  -> failure x


transSession :: Session -> Result
transSession x = case x of
  End  -> failure x
  Par rsessions  -> failure x
  Ten rsessions  -> failure x
  Seq rsessions  -> failure x
  Sort term1 term2  -> failure x
  Log session  -> failure x
  Fwd n session  -> failure x
  Snd term csession  -> failure x
  Rcv term csession  -> failure x
  Dual session  -> failure x
  Loli session1 session2  -> failure x


transRSession :: RSession -> Result
transRSession x = case x of
  Repl session optrepl  -> failure x


transOptRepl :: OptRepl -> Result
transOptRepl x = case x of
  One  -> failure x
  Some term  -> failure x


transCSession :: CSession -> Result
transCSession x = case x of
  Cont session  -> failure x
  Done  -> failure x


