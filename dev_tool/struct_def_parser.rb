# -*- coding: utf-8 -*-
require 'functional_parser'

class TSDefParser < FunctionalParser
  def self.whitespace
    many(char("\s") | char("\n") | char("\t") | char("　")) >> proc{
      ret(nil)
    }
  end

  def self.literal
    (char("‘") | char("'")) >> proc{
      ident >> proc{|i|
        (char("’") | char("'")) >> proc{
          ret(i)
        }}}
  end

  def self.const
    token(literal) >> proc{|i|
      ret("const" + i)
    }
  end

  def self.alphanum
    alpha | digit | char('_')
  end
      
  def self.data_name
    identifier | const
  end

  def self.bits
    natural
  end

  def self.type
    identifier
  end

  def self.data
    data_name >> proc{|n|
      bits >> proc{|b|
        type >> proc{|t|
          ret(kind: :data, name: n, bits: b, type: t)
        }}}
  end

  def self.structure_name
    data_name >> proc{|n|
      token(string("()")) >> proc{
        ret(kind: :strname, name: n)
      }}
  end
      
  def self.statement
    data | _for | _if | _else | structure_name
  end

  def self.structure
    structure_name >> proc{|n|
      token(string("{")) >> proc{
        many(statement) >> proc{|sts|
          token(string("}")) >> proc{
            ret(kind: :struct, name: n[:name], ch: sts)
          }}}}
  end

  def self.for_head
    token(string("for")) >> proc{
      token(char('(')) >> proc{
        many(alphanum | char('<') | char(';')| char('=') | char('+')) >> proc{
          token(char(')')) >> proc{
            token(char('{')) >> proc{
              ret(nil)
            }}}}}
  end

  def self._for
    for_head >> proc{
      many(statement) >> proc{|sts|
        token(string("}")) >> proc{
          ret(kind: :for, ch: sts)
        }}}
  end

  def self.if_eq
    token(char("=")) >> proc{
      token(char("=")) >> proc{
        ret(nil)
      }}
  end

  def self.if_single_exp
    identifier >> proc{|left|
      if_eq >> proc{
        literal >> proc{|i|
          ret(kind: :if_exp, left: left, right: i)
        }}}
  end

  def self.if_exp_cont
    token(string("||")) >> proc{
      if_single_exp >> proc{|e|
        ret(e)
      }}
  end

  def self.if_exp
    if_single_exp >> proc{|head|
      many(if_exp_cont) >> proc{|rest|
        ret([head] + rest)
      }}
  end

  def self._else
    token(string("else")) >> proc{
      token(string("{")) >> proc{
        many(statement) >> proc{|sts|
          token(string("}")) >> proc{
            ret(kind: :else, ch: sts)
          }}}}
  end

  def self._if
    token(string("if")) >> proc{
      token(string("(")) >> proc{
        if_exp >> proc{|es|
          token(string(")")) >> proc{
            token(string("{")) >> proc{
              many(statement) >> proc{|sts|
                token(string("}")) >> proc{
                  ret(kind: :if, exps: es, ch: sts)
                }}}}}}}
  end
end
   

  
