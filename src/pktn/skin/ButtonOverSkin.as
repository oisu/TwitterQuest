package pktn.skin {

  import mx.skins.ProgrammaticSkin;

  public class ButtonOverSkin extends ProgrammaticSkin {

    // Constructor.
    public function ButtonOverSkin() {
      super();
    }

    override protected function updateDisplayList(unscaledWidth:Number,
      unscaledHeight:Number):void
    {
      graphics.lineStyle(0);
      graphics.beginFill(0xFFFFFF);
      graphics.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 20, 20);
    }
  }
}