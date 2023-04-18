part of 'figma_bloc.dart';

class FigmaState {
  Figma? figma;

  FigmaState({this.figma});

  FigmaState setApiKey(String apiKey) {
    Figma figma = Figma();
    figma.id = Figma.DEFAULT_ID;
    figma.apiKey = apiKey;
    return FigmaState(figma: figma);
  }
}
