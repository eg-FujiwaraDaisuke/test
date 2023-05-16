// 引数の数値はFigma上の値
double calcFontHeight({double fontSize = 0, double lineHeight = 0}) {
  return lineHeight / fontSize;
}

// 引数の数値はFigma上の値
double calcLetterSpacing({double letter = 0}) {
  return 1 + letter / 100;
}
