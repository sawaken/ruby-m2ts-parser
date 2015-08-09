# -*- coding: utf-8 -*-

module M2TSParser

  # ----------------------------------------------------------------------------
  # ARIB STD-B10 第2部 表5－1 「SI に対するPID の割当」による
  # ----------------------------------------------------------------------------

  PIDAssocError = Class.new(RuntimeError)

  # PMT, ST, INTは特殊なので除外。
  PIDMAP = {
    :PAT  => [0x0000],
    :CAT  => [0x0001],
    :NIT  => [0x0010],
    :SDT  => [0x0011],
    :BAT  => [0x0011],
    :EIT1 => [0x0012],

    # 地上デジタルテレビジョン放送、マルチメディア放送 (階層毎に対するPID 値の割り当てについては事業者規定による。)
    :EIT2 => [0x0012, 0x0026, 0x0027],

    :RST  => [0x0013],
    :TDT  => [0x0014],
    :TOT  => [0x0014],
    :PCAT => [0x0022],
    :BIT  => [0x0024],
    :NBIT => [0x0025],
    :LDT  => [0x0025],
    # :PMT => PATによる間接指定
    # :INT => PMTによる間接指定
    # :ST => 0x0000, 0x0001, 0x0014を除く
  }

  PIDMAP.default_proc = proc{|h, k| raise PIDAssocError.new("PID=#{k} is undefined")}
end
