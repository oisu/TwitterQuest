package pktn.skin {

  import mx.skins.ProgrammaticSkin;

  public class ButtonUpSkin extends ProgrammaticSkin {

    // Constructor.
    public function ButtonUpSkin() {
      super();
    }

    override protected function updateDisplayList(unscaledWidth:Number,
      unscaledHeight:Number):void
    {
      graphics.lineStyle(0);
      graphics.beginFill(0x000000);
      graphics.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 20, 20);
    }
  }
}