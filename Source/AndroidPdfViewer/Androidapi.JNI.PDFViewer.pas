//====================================================
//
//  转换来自JavaOrClass2Pas(原JavaClassToDelphiUnit)
//  原始作者：ying32
//  QQ: 1444386932、396506155
//  Email：yuanfen3287@vip.qq.com
//
//  修改 By：Flying Wang & 爱吃猪头肉
//  请不要移除以上的任何信息。
//  请不要将本版本发到城通网盘，否则死全家。
//
//  Email：1765535979@qq.com
//  QQ Group：165232328
//
//  生成时间：2018/4/13 14:41:13
//  工具版本：1.0.2016.4.26
//
//====================================================
unit Androidapi.JNI.PDFViewer;

interface

uses
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Util,
  Androidapi.JNI.Net,
  Androidapi.JNI.os,
  Androidapi.JNI.Widget;


type
// ===== Forward declarations =====

  JDragPinchManager = interface; //com.github.barteksc.pdfviewer.DragPinchManager
  JFileNotFoundException = interface; //com.github.barteksc.pdfviewer.exception.FileNotFoundException
  JPageRenderingException = interface; //com.github.barteksc.pdfviewer.exception.PageRenderingException
  JDefaultLinkHandler = interface; //com.github.barteksc.pdfviewer.link.DefaultLinkHandler
  JLinkHandler = interface; //com.github.barteksc.pdfviewer.link.LinkHandler
  JCallbacks = interface; //com.github.barteksc.pdfviewer.listener.Callbacks
  JOnDrawListener = interface; //com.github.barteksc.pdfviewer.listener.OnDrawListener
  JOnErrorListener = interface; //com.github.barteksc.pdfviewer.listener.OnErrorListener
  JOnLoadCompleteListener = interface; //com.github.barteksc.pdfviewer.listener.OnLoadCompleteListener
  JOnPageChangeListener = interface; //com.github.barteksc.pdfviewer.listener.OnPageChangeListener
  JOnPageErrorListener = interface; //com.github.barteksc.pdfviewer.listener.OnPageErrorListener
  JOnPageScrollListener = interface; //com.github.barteksc.pdfviewer.listener.OnPageScrollListener
  JOnRenderListener = interface; //com.github.barteksc.pdfviewer.listener.OnRenderListener
  JOnTapListener = interface; //com.github.barteksc.pdfviewer.listener.OnTapListener
  JLinkTapEvent = interface; //com.github.barteksc.pdfviewer.model.LinkTapEvent
  JPagePart = interface; //com.github.barteksc.pdfviewer.model.PagePart
  JPagesLoader_GridSize = interface; //com.github.barteksc.pdfviewer.PagesLoader$GridSize
  JPagesLoader_Holder = interface; //com.github.barteksc.pdfviewer.PagesLoader$Holder
  JPagesLoader = interface; //com.github.barteksc.pdfviewer.PagesLoader
  JPdfFile = interface; //com.github.barteksc.pdfviewer.PdfFile
  JPDFView_Configurator = interface; //com.github.barteksc.pdfviewer.PDFView$Configurator
  JPDFView_ScrollDir = interface; //com.github.barteksc.pdfviewer.PDFView$ScrollDir
  JPDFView_State = interface; //com.github.barteksc.pdfviewer.PDFView$State
  JPDFView = interface; //com.github.barteksc.pdfviewer.PDFView
  JRenderingHandler_1 = interface; //com.github.barteksc.pdfviewer.RenderingHandler$1
  JRenderingHandler_2 = interface; //com.github.barteksc.pdfviewer.RenderingHandler$2
  JRenderingHandler_RenderingTask = interface; //com.github.barteksc.pdfviewer.RenderingHandler$RenderingTask
  JRenderingHandler = interface; //com.github.barteksc.pdfviewer.RenderingHandler
  JDefaultScrollHandle_1 = interface; //com.github.barteksc.pdfviewer.scroll.DefaultScrollHandle$1
  JDefaultScrollHandle = interface; //com.github.barteksc.pdfviewer.scroll.DefaultScrollHandle
  JScrollHandle = interface; //com.github.barteksc.pdfviewer.scroll.ScrollHandle
  JAssetSource = interface; //com.github.barteksc.pdfviewer.source.AssetSource
  JByteArraySource = interface; //com.github.barteksc.pdfviewer.source.ByteArraySource
  JDocumentSource = interface; //com.github.barteksc.pdfviewer.source.DocumentSource
  JFileSource = interface; //com.github.barteksc.pdfviewer.source.FileSource
  JInputStreamSource = interface; //com.github.barteksc.pdfviewer.source.InputStreamSource
  JUriSource = interface; //com.github.barteksc.pdfviewer.source.UriSource
  JArrayUtils = interface; //com.github.barteksc.pdfviewer.util.ArrayUtils
  JConstants_Cache = interface; //com.github.barteksc.pdfviewer.util.Constants$Cache
  JConstants_Pinch = interface; //com.github.barteksc.pdfviewer.util.Constants$Pinch
  JConstants = interface; //com.github.barteksc.pdfviewer.util.Constants
  JFileUtils = interface; //com.github.barteksc.pdfviewer.util.FileUtils
  JFitPolicy = interface; //com.github.barteksc.pdfviewer.util.FitPolicy
  JMathUtils = interface; //com.github.barteksc.pdfviewer.util.MathUtils
  JPageSizeCalculator = interface; //com.github.barteksc.pdfviewer.util.PageSizeCalculator
  JSnapEdge = interface; //com.github.barteksc.pdfviewer.util.SnapEdge
  JUtil = interface; //com.github.barteksc.pdfviewer.util.Util
  JPdfDocument_Bookmark = interface; //com.shockwave.pdfium.PdfDocument$Bookmark
  JPdfDocument_Link = interface; //com.shockwave.pdfium.PdfDocument$Link
  JPdfDocument_Meta = interface; //com.shockwave.pdfium.PdfDocument$Meta
  JPdfDocument = interface; //com.shockwave.pdfium.PdfDocument
  JPdfiumCore = interface; //com.shockwave.pdfium.PdfiumCore
  JPdfPasswordException = interface; //com.shockwave.pdfium.PdfPasswordException
  JSize = interface; //com.shockwave.pdfium.util.Size
  JSizeF = interface; //com.shockwave.pdfium.util.SizeF

// ===== Interface declarations =====

  JDragPinchManagerClass = interface(JObjectClass)
  ['{E3F6118B-77AA-4912-8918-1044CC031A22}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/DragPinchManager')]
  JDragPinchManager = interface(JObject)
  ['{B7B42BF3-81D5-43C0-A3BA-C0C8E313F547}']
    { Property Methods }

    { methods }
    function onSingleTapConfirmed(e: JMotionEvent): Boolean; cdecl; //(Landroid/view/MotionEvent;)Z
    function onDoubleTap(e: JMotionEvent): Boolean; cdecl; //(Landroid/view/MotionEvent;)Z
    function onDoubleTapEvent(e: JMotionEvent): Boolean; cdecl; //(Landroid/view/MotionEvent;)Z
    function onDown(e: JMotionEvent): Boolean; cdecl; //(Landroid/view/MotionEvent;)Z
    procedure onShowPress(e: JMotionEvent); cdecl; //(Landroid/view/MotionEvent;)V
    function onSingleTapUp(e: JMotionEvent): Boolean; cdecl; //(Landroid/view/MotionEvent;)Z
    function onScroll(e1: JMotionEvent; e2: JMotionEvent; distanceX: Single; distanceY: Single): Boolean; cdecl; //(Landroid/view/MotionEvent;Landroid/view/MotionEvent;FF)Z
    procedure onLongPress(e: JMotionEvent); cdecl; //(Landroid/view/MotionEvent;)V
    function onFling(e1: JMotionEvent; e2: JMotionEvent; velocityX: Single; velocityY: Single): Boolean; cdecl; //(Landroid/view/MotionEvent;Landroid/view/MotionEvent;FF)Z
    function onScale(detector: JScaleGestureDetector): Boolean; cdecl; //(Landroid/view/ScaleGestureDetector;)Z
    function onScaleBegin(detector: JScaleGestureDetector): Boolean; cdecl; //(Landroid/view/ScaleGestureDetector;)Z
    procedure onScaleEnd(detector: JScaleGestureDetector); cdecl; //(Landroid/view/ScaleGestureDetector;)V
    function onTouch(v: JView; event: JMotionEvent): Boolean; cdecl; //(Landroid/view/View;Landroid/view/MotionEvent;)Z

    { Property }
  end;

  TJDragPinchManager = class(TJavaGenericImport<JDragPinchManagerClass, JDragPinchManager>) end;

  JFileNotFoundExceptionClass = interface(JRuntimeExceptionClass) // or JObjectClass // SuperSignature: java/lang/RuntimeException
  ['{0F4BFD91-97C4-45B9-B287-039D0BF3074D}']
    { static Property Methods }

    { static Methods }
    {class} function init(detailMessage: JString): JFileNotFoundException; cdecl; overload; //(Ljava/lang/String;)V
    {class} function init(detailMessage: JString; throwable: JThrowable): JFileNotFoundException; cdecl; overload; //(Ljava/lang/String;Ljava/lang/Throwable;)V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/exception/FileNotFoundException')]
  JFileNotFoundException = interface(JRuntimeException) // or JObject // SuperSignature: java/lang/RuntimeException
  ['{B18C8F43-4534-4827-B46B-270B1CBB6114}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJFileNotFoundException = class(TJavaGenericImport<JFileNotFoundExceptionClass, JFileNotFoundException>) end;

  JPageRenderingExceptionClass = interface(JExceptionClass) // or JObjectClass // SuperSignature: java/lang/Exception
  ['{B16F6D62-2657-43D7-8A92-3DCFA2143978}']
    { static Property Methods }

    { static Methods }
    {class} function init(page: Integer; cause: JThrowable): JPageRenderingException; cdecl; //(ILjava/lang/Throwable;)V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/exception/PageRenderingException')]
  JPageRenderingException = interface(JException) // or JObject // SuperSignature: java/lang/Exception
  ['{042EA2AC-CC62-42B9-99EC-290ECBC5D593}']
    { Property Methods }

    { methods }
    function getPage: Integer; cdecl; //()I

    { Property }
  end;

  TJPageRenderingException = class(TJavaGenericImport<JPageRenderingExceptionClass, JPageRenderingException>) end;

  JDefaultLinkHandlerClass = interface(JObjectClass)
  ['{8EB7D823-0D9B-4B1B-88D8-278DFE9E36D7}']
    { static Property Methods }

    { static Methods }
    {class} function init(pdfView: JPDFView): JDefaultLinkHandler; cdecl; //(Lcom/github/barteksc/pdfviewer/PDFView;)V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/link/DefaultLinkHandler')]
  JDefaultLinkHandler = interface(JObject)
  ['{7F88FB3D-73FD-4761-98E8-FD3B71208CD6}']
    { Property Methods }

    { methods }
    procedure handleLinkEvent(event: JLinkTapEvent); cdecl; //(Lcom/github/barteksc/pdfviewer/model/LinkTapEvent;)V

    { Property }
  end;

  TJDefaultLinkHandler = class(TJavaGenericImport<JDefaultLinkHandlerClass, JDefaultLinkHandler>) end;

  JLinkHandlerClass = interface(JObjectClass)
  ['{9B658FD0-F917-4F2C-A86E-58B202B04CB5}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/link/LinkHandler')]
  JLinkHandler = interface(IJavaInstance)
  ['{72AD5D06-9CF5-463B-BDF8-409E85AB3774}']
    { Property Methods }

    { methods }
    procedure handleLinkEvent(P1: JLinkTapEvent); cdecl; //(Lcom/github/barteksc/pdfviewer/model/LinkTapEvent;)V

    { Property }
  end;

  TJLinkHandler = class(TJavaGenericImport<JLinkHandlerClass, JLinkHandler>) end;

  JCallbacksClass = interface(JObjectClass)
  ['{3893F6A9-86A8-4010-9117-4C97C6194485}']
    { static Property Methods }

    { static Methods }
    {class} function init: JCallbacks; cdecl; //()V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/listener/Callbacks')]
  JCallbacks = interface(JObject)
  ['{D365014B-2AD9-44BD-BE2A-3D4080C96326}']
    { Property Methods }

    { methods }
    procedure setOnLoadComplete(onLoadCompleteListener: JOnLoadCompleteListener); cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnLoadCompleteListener;)V
    procedure callOnLoadComplete(pagesCount: Integer); cdecl; //(I)V
    procedure setOnError(onErrorListener: JOnErrorListener); cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnErrorListener;)V
    function getOnError: JOnErrorListener; cdecl; //()Lcom/github/barteksc/pdfviewer/listener/OnErrorListener;
    procedure setOnPageError(onPageErrorListener: JOnPageErrorListener); cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnPageErrorListener;)V
    function callOnPageError(page: Integer; error: JThrowable): Boolean; cdecl; //(ILjava/lang/Throwable;)Z
    procedure setOnRender(onRenderListener: JOnRenderListener); cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnRenderListener;)V
    procedure callOnRender(pagesCount: Integer); cdecl; //(I)V
    procedure setOnPageChange(onPageChangeListener: JOnPageChangeListener); cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnPageChangeListener;)V
    procedure callOnPageChange(page: Integer; pagesCount: Integer); cdecl; //(II)V
    procedure setOnPageScroll(onPageScrollListener: JOnPageScrollListener); cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnPageScrollListener;)V
    procedure callOnPageScroll(currentPage: Integer; offset: Single); cdecl; //(IF)V
    procedure setOnDraw(onDrawListener: JOnDrawListener); cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnDrawListener;)V
    function getOnDraw: JOnDrawListener; cdecl; //()Lcom/github/barteksc/pdfviewer/listener/OnDrawListener;
    procedure setOnDrawAll(onDrawAllListener: JOnDrawListener); cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnDrawListener;)V
    function getOnDrawAll: JOnDrawListener; cdecl; //()Lcom/github/barteksc/pdfviewer/listener/OnDrawListener;
    procedure setOnTap(onTapListener: JOnTapListener); cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnTapListener;)V
    function callOnTap(event: JMotionEvent): Boolean; cdecl; //(Landroid/view/MotionEvent;)Z
    procedure setLinkHandler(linkHandler: JLinkHandler); cdecl; //(Lcom/github/barteksc/pdfviewer/link/LinkHandler;)V
    procedure callLinkHandler(event: JLinkTapEvent); cdecl; //(Lcom/github/barteksc/pdfviewer/model/LinkTapEvent;)V

    { Property }
  end;

  TJCallbacks = class(TJavaGenericImport<JCallbacksClass, JCallbacks>) end;

  JOnDrawListenerClass = interface(JObjectClass)
  ['{B4EB6006-5D60-41E3-9C6F-8D2445196082}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/listener/OnDrawListener')]
  JOnDrawListener = interface(IJavaInstance)
  ['{FBEE36F3-8A3D-45AC-A27D-22D460EF0152}']
    { Property Methods }

    { methods }
    procedure onLayerDrawn(P1: JCanvas; P2: Single; P3: Single; P4: Integer); cdecl; //(Landroid/graphics/Canvas;FFI)V

    { Property }
  end;

  TJOnDrawListener = class(TJavaGenericImport<JOnDrawListenerClass, JOnDrawListener>) end;

  JOnErrorListenerClass = interface(JObjectClass)
  ['{B63F340C-16A4-40F3-96D1-874BB94AEDF2}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/listener/OnErrorListener')]
  JOnErrorListener = interface(IJavaInstance)
  ['{12B1C084-6DEF-4A71-AA92-71AE041A6163}']
    { Property Methods }

    { methods }
    procedure onError(P1: JThrowable); cdecl; //(Ljava/lang/Throwable;)V

    { Property }
  end;

  TJOnErrorListener = class(TJavaGenericImport<JOnErrorListenerClass, JOnErrorListener>) end;

  JOnLoadCompleteListenerClass = interface(JObjectClass)
  ['{B5E49260-740D-4C36-85E9-B711B3E9F742}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/listener/OnLoadCompleteListener')]
  JOnLoadCompleteListener = interface(IJavaInstance)
  ['{BB13D9F8-E05C-4011-A3C5-7968E7311A6E}']
    { Property Methods }

    { methods }
    procedure loadComplete(P1: Integer); cdecl; //(I)V

    { Property }
  end;

  TJOnLoadCompleteListener = class(TJavaGenericImport<JOnLoadCompleteListenerClass, JOnLoadCompleteListener>) end;

  JOnPageChangeListenerClass = interface(JObjectClass)
  ['{C64666BF-7FA3-4B5F-B2BE-57680BE522B4}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/listener/OnPageChangeListener')]
  JOnPageChangeListener = interface(IJavaInstance)
  ['{3854AFB6-B4E4-4771-BAD1-1FFB9E64E7C0}']
    { Property Methods }

    { methods }
    procedure onPageChanged(P1: Integer; P2: Integer); cdecl; //(II)V

    { Property }
  end;

  TJOnPageChangeListener = class(TJavaGenericImport<JOnPageChangeListenerClass, JOnPageChangeListener>) end;

  JOnPageErrorListenerClass = interface(JObjectClass)
  ['{8FFA8A24-ED3F-4AA9-80A1-DCD7AB46EDDF}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/listener/OnPageErrorListener')]
  JOnPageErrorListener = interface(IJavaInstance)
  ['{0F516E76-C027-469D-AE30-E13AB36E36C1}']
    { Property Methods }

    { methods }
    procedure onPageError(P1: Integer; P2: JThrowable); cdecl; //(ILjava/lang/Throwable;)V

    { Property }
  end;

  TJOnPageErrorListener = class(TJavaGenericImport<JOnPageErrorListenerClass, JOnPageErrorListener>) end;

  JOnPageScrollListenerClass = interface(JObjectClass)
  ['{555DE454-C9BA-442C-AD82-003786B44C35}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/listener/OnPageScrollListener')]
  JOnPageScrollListener = interface(IJavaInstance)
  ['{021F40FE-0653-43CD-B3B8-DA60144509B7}']
    { Property Methods }

    { methods }
    procedure onPageScrolled(P1: Integer; P2: Single); cdecl; //(IF)V

    { Property }
  end;

  TJOnPageScrollListener = class(TJavaGenericImport<JOnPageScrollListenerClass, JOnPageScrollListener>) end;

  JOnRenderListenerClass = interface(JObjectClass)
  ['{803C77E7-84F8-4C4B-BB9B-F05497AEBB41}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/listener/OnRenderListener')]
  JOnRenderListener = interface(IJavaInstance)
  ['{0B0C115E-CF0A-43E8-AD24-4FA0AEFB3CF7}']
    { Property Methods }

    { methods }
    procedure onInitiallyRendered(P1: Integer); cdecl; //(I)V

    { Property }
  end;

  TJOnRenderListener = class(TJavaGenericImport<JOnRenderListenerClass, JOnRenderListener>) end;

  JOnTapListenerClass = interface(JObjectClass)
  ['{86FB279F-6F36-4518-A7A8-975B8995BAF3}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/listener/OnTapListener')]
  JOnTapListener = interface(IJavaInstance)
  ['{4F6A0454-7E62-4359-AC47-A06691CFC9C9}']
    { Property Methods }

    { methods }
    function onTap(P1: JMotionEvent): Boolean; cdecl; //(Landroid/view/MotionEvent;)Z

    { Property }
  end;

  TJOnTapListener = class(TJavaGenericImport<JOnTapListenerClass, JOnTapListener>) end;

  JLinkTapEventClass = interface(JObjectClass)
  ['{705202C9-5BB8-46F9-AC71-41827114CC8D}']
    { static Property Methods }

    { static Methods }
    {class} function init(originalX: Single; originalY: Single; documentX: Single; documentY: Single; mappedLinkRect: JRectF; link: JPdfDocument_Link): JLinkTapEvent; cdecl; //(FFFFLandroid/graphics/RectF;Lcom/shockwave/pdfium/PdfDocument$Link;)V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/model/LinkTapEvent')]
  JLinkTapEvent = interface(JObject)
  ['{4DC7078E-10F6-4241-94D2-AE6B0678DD32}']
    { Property Methods }

    { methods }
    function getOriginalX: Single; cdecl; //()F
    function getOriginalY: Single; cdecl; //()F
    function getDocumentX: Single; cdecl; //()F
    function getDocumentY: Single; cdecl; //()F
    function getMappedLinkRect: JRectF; cdecl; //()Landroid/graphics/RectF;
    function getLink: JPdfDocument_Link; cdecl; //()Lcom/shockwave/pdfium/PdfDocument$Link;

    { Property }
  end;

  TJLinkTapEvent = class(TJavaGenericImport<JLinkTapEventClass, JLinkTapEvent>) end;

  JPagePartClass = interface(JObjectClass)
  ['{7A2A0CFB-567D-4FDD-B773-BF61395AD518}']
    { static Property Methods }

    { static Methods }
    {class} function init(page: Integer; renderedBitmap: JBitmap; pageRelativeBounds: JRectF; thumbnail: Boolean; cacheOrder: Integer): JPagePart; cdecl; //(ILandroid/graphics/Bitmap;Landroid/graphics/RectF;ZI)V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/model/PagePart')]
  JPagePart = interface(JObject)
  ['{60D17A94-2468-4A17-B29C-A512D726516A}']
    { Property Methods }

    { methods }
    function getCacheOrder: Integer; cdecl; //()I
    function getPage: Integer; cdecl; //()I
    function getRenderedBitmap: JBitmap; cdecl; //()Landroid/graphics/Bitmap;
    function getPageRelativeBounds: JRectF; cdecl; //()Landroid/graphics/RectF;
    function isThumbnail: Boolean; cdecl; //()Z
    procedure setCacheOrder(cacheOrder: Integer); cdecl; //(I)V
    function equals(obj: JObject): Boolean; cdecl; //(Ljava/lang/Object;)Z

    { Property }
  end;

  TJPagePart = class(TJavaGenericImport<JPagePartClass, JPagePart>) end;

  JPagesLoader_GridSizeClass = interface(JObjectClass)
  ['{EC37ADA8-C07B-4897-83B5-635692238996}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/PagesLoader$GridSize')]
  JPagesLoader_GridSize = interface(JObject)
  ['{6D232206-7B44-44F7-ACD2-F4CB2CCCA40B}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJPagesLoader_GridSize = class(TJavaGenericImport<JPagesLoader_GridSizeClass, JPagesLoader_GridSize>) end;

  JPagesLoader_HolderClass = interface(JObjectClass)
  ['{8E777DC2-78D1-4470-BB51-A87E728F3634}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/PagesLoader$Holder')]
  JPagesLoader_Holder = interface(JObject)
  ['{985CA2EF-43D7-4E10-8AEC-5E966DFE9DA2}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJPagesLoader_Holder = class(TJavaGenericImport<JPagesLoader_HolderClass, JPagesLoader_Holder>) end;

  JPagesLoaderClass = interface(JObjectClass)
  ['{3A838AB7-2807-40AA-B34D-E027510210F4}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/PagesLoader')]
  JPagesLoader = interface(JObject)
  ['{D9C74A4E-31DE-43E3-A9F7-6D4E2CFEEF62}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJPagesLoader = class(TJavaGenericImport<JPagesLoaderClass, JPagesLoader>) end;

  JPdfFileClass = interface(JObjectClass)
  ['{3281335E-5C4D-4B2C-B1CC-6759CBF91F24}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/PdfFile')]
  JPdfFile = interface(JObject)
  ['{C3906970-4E1F-4CA8-B7B2-D8A6D385462D}']
    { Property Methods }

    { methods }
    procedure recalculatePageSizes(viewSize: JSize); cdecl; //(Lcom/shockwave/pdfium/util/Size;)V
    function getPagesCount: Integer; cdecl; //()I
    function getPageSize(pageIndex: Integer): JSizeF; cdecl; //(I)Lcom/shockwave/pdfium/util/SizeF;
    function getScaledPageSize(pageIndex: Integer; zoom: Single): JSizeF; cdecl; //(IF)Lcom/shockwave/pdfium/util/SizeF;
    function getMaxPageSize: JSizeF; cdecl; //()Lcom/shockwave/pdfium/util/SizeF;
    function getMaxPageWidth: Single; cdecl; //()F
    function getMaxPageHeight: Single; cdecl; //()F
    function getDocLen(zoom: Single): Single; cdecl; //(F)F
    function getPageLength(pageIndex: Integer; zoom: Single): Single; cdecl; //(IF)F
    function getPageSpacing(pageIndex: Integer; zoom: Single): Single; cdecl; //(IF)F
    function getPageOffset(pageIndex: Integer; zoom: Single): Single; cdecl; //(IF)F
    function getSecondaryPageOffset(pageIndex: Integer; zoom: Single): Single; cdecl; //(IF)F
    function getPageAtOffset(offset: Single; zoom: Single): Integer; cdecl; //(FF)I
    function openPage(pageIndex: Integer): Boolean; cdecl; //(I)Z
    function pageHasError(pageIndex: Integer): Boolean; cdecl; //(I)Z
    procedure renderPageBitmap(bitmap: JBitmap; pageIndex: Integer; bounds: JRect; annotationRendering: Boolean); cdecl; //(Landroid/graphics/Bitmap;ILandroid/graphics/Rect;Z)V
    function getMetaData: JPdfDocument_Meta; cdecl; //()Lcom/shockwave/pdfium/PdfDocument$Meta;
    function getBookmarks: JList; cdecl; //()Ljava/util/List;
    function getPageLinks(pageIndex: Integer): JList; cdecl; //(I)Ljava/util/List;
    function mapRectToDevice(pageIndex: Integer; startX: Integer; startY: Integer; sizeX: Integer; sizeY: Integer; rect: JRectF): JRectF; cdecl; //(IIIIILandroid/graphics/RectF;)Landroid/graphics/RectF;
    procedure dispose; cdecl; //()V
    function determineValidPageNumberFrom(userPage: Integer): Integer; cdecl; //(I)I
    function documentPage(userPage: Integer): Integer; cdecl; //(I)I

    { Property }
  end;

  TJPdfFile = class(TJavaGenericImport<JPdfFileClass, JPdfFile>) end;

  JPDFView_ConfiguratorClass = interface(JObjectClass)
  ['{76248676-89E6-4DD6-88AB-A792635EBA01}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/PDFView$Configurator')]
  JPDFView_Configurator = interface(JObject)
  ['{3471750A-5046-4B22-81B3-1B0DD50D4094}']
    { Property Methods }

    { methods }
    function pages(pageNumbers: TJavaArray<Integer>): JPDFView_Configurator; cdecl; //([I)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function enableSwipe(enableSwipe: Boolean): JPDFView_Configurator; cdecl; //(Z)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function enableDoubletap(enableDoubletap: Boolean): JPDFView_Configurator; cdecl; //(Z)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function enableAnnotationRendering(annotationRendering: Boolean): JPDFView_Configurator; cdecl; //(Z)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function onDraw(onDrawListener: JOnDrawListener): JPDFView_Configurator; cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnDrawListener;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function onDrawAll(onDrawAllListener: JOnDrawListener): JPDFView_Configurator; cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnDrawListener;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function onLoad(onLoadCompleteListener: JOnLoadCompleteListener): JPDFView_Configurator; cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnLoadCompleteListener;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function onPageScroll(onPageScrollListener: JOnPageScrollListener): JPDFView_Configurator; cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnPageScrollListener;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function onError(onErrorListener: JOnErrorListener): JPDFView_Configurator; cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnErrorListener;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function onPageError(onPageErrorListener: JOnPageErrorListener): JPDFView_Configurator; cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnPageErrorListener;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function onPageChange(onPageChangeListener: JOnPageChangeListener): JPDFView_Configurator; cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnPageChangeListener;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function onRender(onRenderListener: JOnRenderListener): JPDFView_Configurator; cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnRenderListener;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function onTap(onTapListener: JOnTapListener): JPDFView_Configurator; cdecl; //(Lcom/github/barteksc/pdfviewer/listener/OnTapListener;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function linkHandler(linkHandler: JLinkHandler): JPDFView_Configurator; cdecl; //(Lcom/github/barteksc/pdfviewer/link/LinkHandler;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function defaultPage(defaultPage: Integer): JPDFView_Configurator; cdecl; //(I)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function swipeHorizontal(swipeHorizontal: Boolean): JPDFView_Configurator; cdecl; //(Z)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function password(password: JString): JPDFView_Configurator; cdecl; //(Ljava/lang/String;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function scrollHandle(scrollHandle: JScrollHandle): JPDFView_Configurator; cdecl; //(Lcom/github/barteksc/pdfviewer/scroll/ScrollHandle;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function enableAntialiasing(antialiasing: Boolean): JPDFView_Configurator; cdecl; //(Z)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function spacing(spacing: Integer): JPDFView_Configurator; cdecl; //(I)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function autoSpacing(autoSpacing: Boolean): JPDFView_Configurator; cdecl; //(Z)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function pageFitPolicy(pageFitPolicy: JFitPolicy): JPDFView_Configurator; cdecl; //(Lcom/github/barteksc/pdfviewer/util/FitPolicy;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function pageSnap(pageSnap: Boolean): JPDFView_Configurator; cdecl; //(Z)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function pageFling(pageFling: Boolean): JPDFView_Configurator; cdecl; //(Z)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    procedure load; cdecl; //()V

    { Property }
  end;

  TJPDFView_Configurator = class(TJavaGenericImport<JPDFView_ConfiguratorClass, JPDFView_Configurator>) end;

  JPDFView_ScrollDirClass = interface(JEnumClass) // or JObjectClass // SuperSignature: java/lang/Enum
  ['{C87BECFA-0A6A-475F-A450-6FFE7433A074}']
    { static Property Methods }
    {class} function _GetNONE: JPDFView_ScrollDir; //Lcom/github/barteksc/pdfviewer/PDFView$ScrollDir;
    {class} function _GetSTART: JPDFView_ScrollDir; //Lcom/github/barteksc/pdfviewer/PDFView$ScrollDir;
    {class} function _GetEND: JPDFView_ScrollDir; //Lcom/github/barteksc/pdfviewer/PDFView$ScrollDir;

    { static Methods }
    {class} function values: TJavaObjectArray<JPDFView_ScrollDir>; cdecl; //()[Lcom/github/barteksc/pdfviewer/PDFView$ScrollDir;
    {class} function valueOf(P1: JString): JPDFView_ScrollDir; cdecl; //(Ljava/lang/String;)Lcom/github/barteksc/pdfviewer/PDFView$ScrollDir;

    { static Property }
    {class} property NONE: JPDFView_ScrollDir read _GetNONE;
    {class} property START: JPDFView_ScrollDir read _GetSTART;
    {class} property &END: JPDFView_ScrollDir read _GetEND;
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/PDFView$ScrollDir')]
  JPDFView_ScrollDir = interface(JEnum) // or JObject // SuperSignature: java/lang/Enum
  ['{FACBDA6C-4674-429B-AB27-77CE05220778}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJPDFView_ScrollDir = class(TJavaGenericImport<JPDFView_ScrollDirClass, JPDFView_ScrollDir>) end;

  JPDFView_StateClass = interface(JEnumClass) // or JObjectClass // SuperSignature: java/lang/Enum
  ['{774A73BB-4A8E-4749-9074-7DAA39F5A284}']
    { static Property Methods }
    {class} function _GetDEFAULT: JPDFView_State; //Lcom/github/barteksc/pdfviewer/PDFView$State;
    {class} function _GetLOADED: JPDFView_State; //Lcom/github/barteksc/pdfviewer/PDFView$State;
    {class} function _GetSHOWN: JPDFView_State; //Lcom/github/barteksc/pdfviewer/PDFView$State;
    {class} function _GetERROR: JPDFView_State; //Lcom/github/barteksc/pdfviewer/PDFView$State;

    { static Methods }
    {class} function values: TJavaObjectArray<JPDFView_State>; cdecl; //()[Lcom/github/barteksc/pdfviewer/PDFView$State;
    {class} function valueOf(P1: JString): JPDFView_State; cdecl; //(Ljava/lang/String;)Lcom/github/barteksc/pdfviewer/PDFView$State;

    { static Property }
    {class} property DEFAULT: JPDFView_State read _GetDEFAULT;
    {class} property LOADED: JPDFView_State read _GetLOADED;
    {class} property SHOWN: JPDFView_State read _GetSHOWN;
    {class} property ERROR: JPDFView_State read _GetERROR;
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/PDFView$State')]
  JPDFView_State = interface(JEnum) // or JObject // SuperSignature: java/lang/Enum
  ['{DAF3D39D-9CA3-48E8-80D6-3CEF0834F8A0}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJPDFView_State = class(TJavaGenericImport<JPDFView_StateClass, JPDFView_State>) end;

  JPDFViewClass = interface(JRelativeLayoutClass) // or JObjectClass // SuperSignature: android/widget/RelativeLayout
  ['{7BE0B45F-E8E8-4362-ABE3-755359C30EF4}']
    { static Property Methods }
    {class} function _GetDEFAULT_MAX_SCALE: Single; //F
    {class} function _GetDEFAULT_MID_SCALE: Single; //F
    {class} function _GetDEFAULT_MIN_SCALE: Single; //F

    { static Methods }
    {class} function init(context: JContext; aset: JAttributeSet): JPDFView; cdecl; //(Landroid/content/Context;Landroid/util/AttributeSet;)V

    { static Property }
    {class} property DEFAULT_MAX_SCALE: Single read _GetDEFAULT_MAX_SCALE;
    {class} property DEFAULT_MID_SCALE: Single read _GetDEFAULT_MID_SCALE;
    {class} property DEFAULT_MIN_SCALE: Single read _GetDEFAULT_MIN_SCALE;
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/PDFView')]
  JPDFView = interface(JRelativeLayout) // or JObject // SuperSignature: android/widget/RelativeLayout
  ['{E2C66519-4FC3-4493-B394-760FB58098BB}']
    { Property Methods }

    { methods }
    procedure jumpTo(page: Integer; withAnimation: Boolean); cdecl; overload; //(IZ)V
    procedure jumpTo(page: Integer); cdecl; overload; //(I)V
    function getPositionOffset: Single; cdecl; //()F
    procedure setPositionOffset(progress: Single; moveHandle: Boolean); cdecl; overload; //(FZ)V
    procedure setPositionOffset(progress: Single); cdecl; overload; //(F)V
    procedure stopFling; cdecl; //()V
    function getPageCount: Integer; cdecl; //()I
    procedure setSwipeEnabled(enableSwipe: Boolean); cdecl; //(Z)V
    procedure recycle; cdecl; //()V
    function isRecycled: Boolean; cdecl; //()Z
    procedure computeScroll; cdecl; //()V
    function canScrollHorizontally(direction: Integer): Boolean; cdecl; //(I)Z
    function canScrollVertically(direction: Integer): Boolean; cdecl; //(I)Z
    procedure loadPages; cdecl; //()V
    procedure onBitmapRendered(part: JPagePart); cdecl; //(Lcom/github/barteksc/pdfviewer/model/PagePart;)V
    procedure moveTo(offsetX: Single; offsetY: Single); cdecl; overload; //(FF)V
    procedure moveTo(offsetX: Single; offsetY: Single; moveHandle: Boolean); cdecl; overload; //(FFZ)V
    procedure performPageSnap; cdecl; //()V
    function pageFillsScreen: Boolean; cdecl; //()Z
    procedure moveRelativeTo(dx: Single; dy: Single); cdecl; //(FF)V
    procedure zoomTo(zoom: Single); cdecl; //(F)V
    procedure zoomCenteredTo(zoom: Single; pivot: JPointF); cdecl; //(FLandroid/graphics/PointF;)V
    procedure zoomCenteredRelativeTo(dzoom: Single; pivot: JPointF); cdecl; //(FLandroid/graphics/PointF;)V
    function documentFitsView: Boolean; cdecl; //()Z
    procedure fitToWidth(page: Integer); cdecl; //(I)V
    function getPageSize(pageIndex: Integer): JSizeF; cdecl; //(I)Lcom/shockwave/pdfium/util/SizeF;
    function getCurrentPage: Integer; cdecl; //()I
    function getCurrentXOffset: Single; cdecl; //()F
    function getCurrentYOffset: Single; cdecl; //()F
    function toRealScale(size: Single): Single; cdecl; //(F)F
    function toCurrentScale(size: Single): Single; cdecl; //(F)F
    function getZoom: Single; cdecl; //()F
    function isZooming: Boolean; cdecl; //()Z
    procedure resetZoom; cdecl; //()V
    procedure resetZoomWithAnimation; cdecl; //()V
    procedure zoomWithAnimation(centerX: Single; centerY: Single; scale: Single); cdecl; overload; //(FFF)V
    procedure zoomWithAnimation(scale: Single); cdecl; overload; //(F)V
    function getPageAtPositionOffset(positionOffset: Single): Integer; cdecl; //(F)I
    function getMinZoom: Single; cdecl; //()F
    procedure setMinZoom(minZoom: Single); cdecl; //(F)V
    function getMidZoom: Single; cdecl; //()F
    procedure setMidZoom(midZoom: Single); cdecl; //(F)V
    function getMaxZoom: Single; cdecl; //()F
    procedure setMaxZoom(maxZoom: Single); cdecl; //(F)V
    procedure useBestQuality(bestQuality: Boolean); cdecl; //(Z)V
    function isBestQuality: Boolean; cdecl; //()Z
    function isSwipeVertical: Boolean; cdecl; //()Z
    function isSwipeEnabled: Boolean; cdecl; //()Z
    procedure enableAnnotationRendering(annotationRendering: Boolean); cdecl; //(Z)V
    function isAnnotationRendering: Boolean; cdecl; //()Z
    procedure enableRenderDuringScale(renderDuringScale: Boolean); cdecl; //(Z)V
    function isAntialiasing: Boolean; cdecl; //()Z
    procedure enableAntialiasing(enableAntialiasing: Boolean); cdecl; //(Z)V
    function getSpacingPx: Integer; cdecl; //()I
    function doAutoSpacing: Boolean; cdecl; //()Z
    procedure setPageFling(pageFling: Boolean); cdecl; //(Z)V
    function doPageFling: Boolean; cdecl; //()Z
    function getPageFitPolicy: JFitPolicy; cdecl; //()Lcom/github/barteksc/pdfviewer/util/FitPolicy;
    function doPageSnap: Boolean; cdecl; //()Z
    procedure setPageSnap(pageSnap: Boolean); cdecl; //(Z)V
    function doRenderDuringScale: Boolean; cdecl; //()Z
    function getDocumentMeta: JPdfDocument_Meta; cdecl; //()Lcom/shockwave/pdfium/PdfDocument$Meta;
    function getTableOfContents: JList; cdecl; //()Ljava/util/List;
    function getLinks(page: Integer): JList; cdecl; //(I)Ljava/util/List;
    function fromAsset(assetName: JString): JPDFView_Configurator; cdecl; //(Ljava/lang/String;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function fromFile(afile: JFile): JPDFView_Configurator; cdecl; //(Ljava/io/File;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function fromUri(uri: Jnet_Uri): JPDFView_Configurator; cdecl; //(Landroid/net/Uri;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function fromBytes(bytes: TJavaArray<Byte>): JPDFView_Configurator; cdecl; //([B)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function fromStream(stream: JInputStream): JPDFView_Configurator; cdecl; //(Ljava/io/InputStream;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;
    function fromSource(docSource: JDocumentSource): JPDFView_Configurator; cdecl; //(Lcom/github/barteksc/pdfviewer/source/DocumentSource;)Lcom/github/barteksc/pdfviewer/PDFView$Configurator;

    { Property }
  end;

  TJPDFView = class(TJavaGenericImport<JPDFViewClass, JPDFView>) end;

  JRenderingHandler_1Class = interface(JObjectClass)
  ['{ABD0AC21-AB91-48A1-8FE1-4410A4FA79A2}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/RenderingHandler$1')]
  JRenderingHandler_1 = interface(JObject)
  ['{7DBB65D6-0F6F-4106-9E75-D3997F0F1CA1}']
    { Property Methods }

    { methods }
    procedure run; cdecl; //()V

    { Property }
  end;

  TJRenderingHandler_1 = class(TJavaGenericImport<JRenderingHandler_1Class, JRenderingHandler_1>) end;

  JRenderingHandler_2Class = interface(JObjectClass)
  ['{5B3DFAAA-4E6C-4A66-88F1-75B4E47EF25E}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/RenderingHandler$2')]
  JRenderingHandler_2 = interface(JObject)
  ['{F65B1B15-4FE1-41ED-AB80-E1CFF8B8AC11}']
    { Property Methods }

    { methods }
    procedure run; cdecl; //()V

    { Property }
  end;

  TJRenderingHandler_2 = class(TJavaGenericImport<JRenderingHandler_2Class, JRenderingHandler_2>) end;

  JRenderingHandler_RenderingTaskClass = interface(JObjectClass)
  ['{14415FEA-4176-43D0-A19C-F6FA43C39FC7}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/RenderingHandler$RenderingTask')]
  JRenderingHandler_RenderingTask = interface(JObject)
  ['{E17F4CA1-0093-416D-88E4-1A3BE7F62B6F}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJRenderingHandler_RenderingTask = class(TJavaGenericImport<JRenderingHandler_RenderingTaskClass, JRenderingHandler_RenderingTask>) end;

  JRenderingHandlerClass = interface(JHandlerClass) // or JObjectClass // SuperSignature: android/os/Handler
  ['{0D687D95-1EA2-4494-ADE2-2829739C9D1F}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/RenderingHandler')]
  JRenderingHandler = interface(JHandler) // or JObject // SuperSignature: android/os/Handler
  ['{21EFD93F-6E80-4718-807D-D3843EFD8A83}']
    { Property Methods }

    { methods }
    procedure handleMessage(amessage: JMessage); cdecl; //(Landroid/os/Message;)V

    { Property }
  end;

  TJRenderingHandler = class(TJavaGenericImport<JRenderingHandlerClass, JRenderingHandler>) end;

  JDefaultScrollHandle_1Class = interface(JObjectClass)
  ['{F1972916-879D-40D5-BBDC-4BA5978D4CDB}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/scroll/DefaultScrollHandle$1')]
  JDefaultScrollHandle_1 = interface(JObject)
  ['{65A22589-612F-4CEF-AD8F-989E1968202B}']
    { Property Methods }

    { methods }
    procedure run; cdecl; //()V

    { Property }
  end;

  TJDefaultScrollHandle_1 = class(TJavaGenericImport<JDefaultScrollHandle_1Class, JDefaultScrollHandle_1>) end;

  JDefaultScrollHandleClass = interface(JRelativeLayoutClass) // or JObjectClass // SuperSignature: android/widget/RelativeLayout
  ['{0BED8D00-DEEE-4E15-AC43-764A0E5E7B74}']
    { static Property Methods }

    { static Methods }
    {class} function init(context: JContext): JDefaultScrollHandle; cdecl; overload; //(Landroid/content/Context;)V
    {class} function init(context: JContext; inverted: Boolean): JDefaultScrollHandle; cdecl; overload; //(Landroid/content/Context;Z)V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/scroll/DefaultScrollHandle')]
  JDefaultScrollHandle = interface(JRelativeLayout) // or JObject // SuperSignature: android/widget/RelativeLayout
  ['{F24B8663-93E2-40E4-88F9-D6744495C1A9}']
    { Property Methods }

    { methods }
    procedure setupLayout(pdfView: JPDFView); cdecl; //(Lcom/github/barteksc/pdfviewer/PDFView;)V
    procedure destroyLayout; cdecl; //()V
    procedure setScroll(position: Single); cdecl; //(F)V
    procedure hideDelayed; cdecl; //()V
    procedure setPageNum(pageNum: Integer); cdecl; //(I)V
    function shown: Boolean; cdecl; //()Z
    procedure show; cdecl; //()V
    procedure hide; cdecl; //()V
    procedure setTextColor(color: Integer); cdecl; //(I)V
    procedure setTextSize(size: Integer); cdecl; //(I)V
    function onTouchEvent(event: JMotionEvent): Boolean; cdecl; //(Landroid/view/MotionEvent;)Z

    { Property }
  end;

  TJDefaultScrollHandle = class(TJavaGenericImport<JDefaultScrollHandleClass, JDefaultScrollHandle>) end;

  JScrollHandleClass = interface(JObjectClass)
  ['{0C1A6AF1-CAB9-4F2F-9B2B-38F4781C7386}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/scroll/ScrollHandle')]
  JScrollHandle = interface(IJavaInstance)
  ['{79B4190E-1F0C-4A00-A137-3EE00C98A425}']
    { Property Methods }

    { methods }
    procedure setScroll(P1: Single); cdecl; //(F)V
    procedure setupLayout(P1: JPDFView); cdecl; //(Lcom/github/barteksc/pdfviewer/PDFView;)V
    procedure destroyLayout; cdecl; //()V
    procedure setPageNum(P1: Integer); cdecl; //(I)V
    function shown: Boolean; cdecl; //()Z
    procedure show; cdecl; //()V
    procedure hide; cdecl; //()V
    procedure hideDelayed; cdecl; //()V

    { Property }
  end;

  TJScrollHandle = class(TJavaGenericImport<JScrollHandleClass, JScrollHandle>) end;

  JAssetSourceClass = interface(JObjectClass)
  ['{49AB128E-ED96-4113-A009-719A5DE62DCA}']
    { static Property Methods }

    { static Methods }
    {class} function init(assetName: JString): JAssetSource; cdecl; //(Ljava/lang/String;)V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/source/AssetSource')]
  JAssetSource = interface(JObject)
  ['{F510D3EF-184A-415F-B814-A4180352BA48}']
    { Property Methods }

    { methods }
    function createDocument(context: JContext; core: JPdfiumCore; password: JString): JPdfDocument; cdecl; //(Landroid/content/Context;Lcom/shockwave/pdfium/PdfiumCore;Ljava/lang/String;)Lcom/shockwave/pdfium/PdfDocument;

    { Property }
  end;

  TJAssetSource = class(TJavaGenericImport<JAssetSourceClass, JAssetSource>) end;

  JByteArraySourceClass = interface(JObjectClass)
  ['{A9803C30-C0E9-41E2-A409-9300A888DE44}']
    { static Property Methods }

    { static Methods }
    {class} function init(data: TJavaArray<Byte>): JByteArraySource; cdecl; //([B)V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/source/ByteArraySource')]
  JByteArraySource = interface(JObject)
  ['{04BC47A8-DEF5-4A57-B3CE-36AFDB555D42}']
    { Property Methods }

    { methods }
    function createDocument(context: JContext; core: JPdfiumCore; password: JString): JPdfDocument; cdecl; //(Landroid/content/Context;Lcom/shockwave/pdfium/PdfiumCore;Ljava/lang/String;)Lcom/shockwave/pdfium/PdfDocument;

    { Property }
  end;

  TJByteArraySource = class(TJavaGenericImport<JByteArraySourceClass, JByteArraySource>) end;

  JDocumentSourceClass = interface(JObjectClass)
  ['{79B3A6DE-5DCB-4057-803F-5721F02E4BB9}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/source/DocumentSource')]
  JDocumentSource = interface(IJavaInstance)
  ['{8CA5E3E8-CC72-4B77-AC05-EAFB05E307B3}']
    { Property Methods }

    { methods }
    function createDocument(P1: JContext; P2: JPdfiumCore; P3: JString): JPdfDocument; cdecl; //(Landroid/content/Context;Lcom/shockwave/pdfium/PdfiumCore;Ljava/lang/String;)Lcom/shockwave/pdfium/PdfDocument;

    { Property }
  end;

  TJDocumentSource = class(TJavaGenericImport<JDocumentSourceClass, JDocumentSource>) end;

  JFileSourceClass = interface(JObjectClass)
  ['{A3CD8DE8-DE2C-42DA-998C-243490F0524E}']
    { static Property Methods }

    { static Methods }
    {class} function init(afile: JFile): JFileSource; cdecl; //(Ljava/io/File;)V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/source/FileSource')]
  JFileSource = interface(JObject)
  ['{7AD0FFA0-DAB4-4331-A7EB-A61FACFB1149}']
    { Property Methods }

    { methods }
    function createDocument(context: JContext; core: JPdfiumCore; password: JString): JPdfDocument; cdecl; //(Landroid/content/Context;Lcom/shockwave/pdfium/PdfiumCore;Ljava/lang/String;)Lcom/shockwave/pdfium/PdfDocument;

    { Property }
  end;

  TJFileSource = class(TJavaGenericImport<JFileSourceClass, JFileSource>) end;

  JInputStreamSourceClass = interface(JObjectClass)
  ['{D7FC6F79-D376-4416-9157-92D30C8F4A81}']
    { static Property Methods }

    { static Methods }
    {class} function init(inputStream: JInputStream): JInputStreamSource; cdecl; //(Ljava/io/InputStream;)V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/source/InputStreamSource')]
  JInputStreamSource = interface(JObject)
  ['{C49C50AC-F892-46EA-895C-B8713321B139}']
    { Property Methods }

    { methods }
    function createDocument(context: JContext; core: JPdfiumCore; password: JString): JPdfDocument; cdecl; //(Landroid/content/Context;Lcom/shockwave/pdfium/PdfiumCore;Ljava/lang/String;)Lcom/shockwave/pdfium/PdfDocument;

    { Property }
  end;

  TJInputStreamSource = class(TJavaGenericImport<JInputStreamSourceClass, JInputStreamSource>) end;

  JUriSourceClass = interface(JObjectClass)
  ['{EE37FE56-00F3-4825-BA73-D9E9AC892B41}']
    { static Property Methods }

    { static Methods }
    {class} function init(uri: Jnet_Uri): JUriSource; cdecl; //(Landroid/net/Uri;)V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/source/UriSource')]
  JUriSource = interface(JObject)
  ['{39FEDB18-74DE-469B-9CE6-D3A388C5E8CB}']
    { Property Methods }

    { methods }
    function createDocument(context: JContext; core: JPdfiumCore; password: JString): JPdfDocument; cdecl; //(Landroid/content/Context;Lcom/shockwave/pdfium/PdfiumCore;Ljava/lang/String;)Lcom/shockwave/pdfium/PdfDocument;

    { Property }
  end;

  TJUriSource = class(TJavaGenericImport<JUriSourceClass, JUriSource>) end;

  JArrayUtilsClass = interface(JObjectClass)
  ['{95B932C1-9141-494A-965B-AF553FAAE951}']
    { static Property Methods }

    { static Methods }
    {class} function deleteDuplicatedPages(result: TJavaArray<Integer>): TJavaArray<Integer>; cdecl; //([I)[I
    {class} function calculateIndexesInDuplicateArray(result: TJavaArray<Integer>): TJavaArray<Integer>; cdecl; //([I)[I
    {class} function arrayToString(builder: TJavaArray<Integer>): JString; cdecl; //([I)Ljava/lang/String;

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/util/ArrayUtils')]
  JArrayUtils = interface(JObject)
  ['{5B75DA0A-F22D-425E-BD92-C542D13841BA}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJArrayUtils = class(TJavaGenericImport<JArrayUtilsClass, JArrayUtils>) end;

  JConstants_CacheClass = interface(JObjectClass)
  ['{D1BEE57A-8347-42B5-8A1D-ADE7707C448A}']
    { static Property Methods }
    {class} function _GetCACHE_SIZE: Integer; //I
    {class} function _GetTHUMBNAILS_CACHE_SIZE: Integer; //I

    { static Methods }
    {class} function init: JConstants_Cache; cdecl; //()V

    { static Property }
    {class} property CACHE_SIZE: Integer read _GetCACHE_SIZE;
    {class} property THUMBNAILS_CACHE_SIZE: Integer read _GetTHUMBNAILS_CACHE_SIZE;
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/util/Constants$Cache')]
  JConstants_Cache = interface(JObject)
  ['{4DCC5012-DCFE-4566-933E-836043C521AD}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJConstants_Cache = class(TJavaGenericImport<JConstants_CacheClass, JConstants_Cache>) end;

  JConstants_PinchClass = interface(JObjectClass)
  ['{202751DC-8729-4DE1-92FA-2F9CA4DA21EE}']
    { static Property Methods }
    {class} function _GetMAXIMUM_ZOOM: Single; //F
    {class} function _GetMINIMUM_ZOOM: Single; //F

    { static Methods }
    {class} function init: JConstants_Pinch; cdecl; //()V

    { static Property }
    {class} property MAXIMUM_ZOOM: Single read _GetMAXIMUM_ZOOM;
    {class} property MINIMUM_ZOOM: Single read _GetMINIMUM_ZOOM;
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/util/Constants$Pinch')]
  JConstants_Pinch = interface(JObject)
  ['{75A69444-396A-44A3-9234-305F7B09B908}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJConstants_Pinch = class(TJavaGenericImport<JConstants_PinchClass, JConstants_Pinch>) end;

  JConstantsClass = interface(JObjectClass)
  ['{008FA332-9998-444F-9880-3B519221DF07}']
    { static Property Methods }
    {class} function _GetDEBUG_MODE: Boolean; //Z
    {class} function _GetTHUMBNAIL_RATIO: Single; //F
    {class} function _GetPART_SIZE: Single; //F
    {class} function _GetPRELOAD_OFFSET: Integer; //I

    { static Methods }
    {class} function init: JConstants; cdecl; //()V

    { static Property }
    {class} property DEBUG_MODE: Boolean read _GetDEBUG_MODE;
    {class} property THUMBNAIL_RATIO: Single read _GetTHUMBNAIL_RATIO;
    {class} property PART_SIZE: Single read _GetPART_SIZE;
    {class} property PRELOAD_OFFSET: Integer read _GetPRELOAD_OFFSET;
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/util/Constants')]
  JConstants = interface(JObject)
  ['{EBF7E928-FD1A-45F2-AC38-75DA3FB005DD}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJConstants = class(TJavaGenericImport<JConstantsClass, JConstants>) end;

  JFileUtilsClass = interface(JObjectClass)
  ['{1514280C-84AF-4E6B-BE3D-F5CFFA3EB13D}']
    { static Property Methods }

    { static Methods }
    {class} function fileFromAsset(assetName: JContext; outFile: JString): JFile; cdecl; //(Landroid/content/Context;Ljava/lang/String;)Ljava/io/File;
    {class} procedure copy(output: JInputStream; outputStream: JFile); cdecl; //(Ljava/io/InputStream;Ljava/io/File;)V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/util/FileUtils')]
  JFileUtils = interface(JObject)
  ['{6B7B6226-3A56-4C86-90B9-FB482FB0D296}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJFileUtils = class(TJavaGenericImport<JFileUtilsClass, JFileUtils>) end;

  JFitPolicyClass = interface(JEnumClass) // or JObjectClass // SuperSignature: java/lang/Enum
  ['{5962C718-0AD9-4BA0-A3B7-5C5B1EE3B342}']
    { static Property Methods }
    {class} function _GetWIDTH: JFitPolicy; //Lcom/github/barteksc/pdfviewer/util/FitPolicy;
    {class} function _GetHEIGHT: JFitPolicy; //Lcom/github/barteksc/pdfviewer/util/FitPolicy;
    {class} function _GetBOTH: JFitPolicy; //Lcom/github/barteksc/pdfviewer/util/FitPolicy;

    { static Methods }
    {class} function values: TJavaObjectArray<JFitPolicy>; cdecl; //()[Lcom/github/barteksc/pdfviewer/util/FitPolicy;
    {class} function valueOf(P1: JString): JFitPolicy; cdecl; //(Ljava/lang/String;)Lcom/github/barteksc/pdfviewer/util/FitPolicy;

    { static Property }
    {class} property WIDTH: JFitPolicy read _GetWIDTH;
    {class} property HEIGHT: JFitPolicy read _GetHEIGHT;
    {class} property BOTH: JFitPolicy read _GetBOTH;
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/util/FitPolicy')]
  JFitPolicy = interface(JEnum) // or JObject // SuperSignature: java/lang/Enum
  ['{D256100F-68B2-4588-8D18-83BDF8579052}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJFitPolicy = class(TJavaGenericImport<JFitPolicyClass, JFitPolicy>) end;

  JMathUtilsClass = interface(JObjectClass)
  ['{5F2AC2BD-09B4-4F53-96B3-4E1773F74CFB}']
    { static Property Methods }

    { static Methods }
    {class} function limit(between: Integer; aand: Integer; P3: Integer): Integer; cdecl; overload; //(III)I
    {class} function limit(between: Single; aand: Single; P3: Single): Single; cdecl; overload; //(FFF)F
    {class} function max(max: Single; P2: Single): Single; cdecl; overload; //(FF)F
    {class} function min(min: Single; P2: Single): Single; cdecl; overload; //(FF)F
    {class} function max(max: Integer; P2: Integer): Integer; cdecl; overload; //(II)I
    {class} function min(min: Integer; P2: Integer): Integer; cdecl; overload; //(II)I
    {class} function floor(P1: Single): Integer; cdecl; //(F)I
    {class} function ceil(P1: Single): Integer; cdecl; //(F)I

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/util/MathUtils')]
  JMathUtils = interface(JObject)
  ['{0BF12C7F-6904-4858-BBAC-74D6F768D250}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJMathUtils = class(TJavaGenericImport<JMathUtilsClass, JMathUtils>) end;

  JPageSizeCalculatorClass = interface(JObjectClass)
  ['{E96AC2A7-405D-4FDE-954F-CCF9AD808C14}']
    { static Property Methods }

    { static Methods }
    {class} function init(fitPolicy: JFitPolicy; originalMaxWidthPageSize: JSize; originalMaxHeightPageSize: JSize; viewSize: JSize): JPageSizeCalculator; cdecl; //(Lcom/github/barteksc/pdfviewer/util/FitPolicy;Lcom/shockwave/pdfium/util/Size;Lcom/shockwave/pdfium/util/Size;Lcom/shockwave/pdfium/util/Size;)V

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/util/PageSizeCalculator')]
  JPageSizeCalculator = interface(JObject)
  ['{7804A0DD-5C5D-4809-BD95-E71A1740551A}']
    { Property Methods }

    { methods }
    function calculate(pageSize: JSize): JSizeF; cdecl; //(Lcom/shockwave/pdfium/util/Size;)Lcom/shockwave/pdfium/util/SizeF;
    function getOptimalMaxWidthPageSize: JSizeF; cdecl; //()Lcom/shockwave/pdfium/util/SizeF;
    function getOptimalMaxHeightPageSize: JSizeF; cdecl; //()Lcom/shockwave/pdfium/util/SizeF;

    { Property }
  end;

  TJPageSizeCalculator = class(TJavaGenericImport<JPageSizeCalculatorClass, JPageSizeCalculator>) end;

  JSnapEdgeClass = interface(JEnumClass) // or JObjectClass // SuperSignature: java/lang/Enum
  ['{9F5FE494-ADAA-4E4B-A476-86711F1D029C}']
    { static Property Methods }
    {class} function _GetSTART: JSnapEdge; //Lcom/github/barteksc/pdfviewer/util/SnapEdge;
    {class} function _GetCENTER: JSnapEdge; //Lcom/github/barteksc/pdfviewer/util/SnapEdge;
    {class} function _GetEND: JSnapEdge; //Lcom/github/barteksc/pdfviewer/util/SnapEdge;
    {class} function _GetNONE: JSnapEdge; //Lcom/github/barteksc/pdfviewer/util/SnapEdge;

    { static Methods }
    {class} function values: TJavaObjectArray<JSnapEdge>; cdecl; //()[Lcom/github/barteksc/pdfviewer/util/SnapEdge;
    {class} function valueOf(P1: JString): JSnapEdge; cdecl; //(Ljava/lang/String;)Lcom/github/barteksc/pdfviewer/util/SnapEdge;

    { static Property }
    {class} property START: JSnapEdge read _GetSTART;
    {class} property CENTER: JSnapEdge read _GetCENTER;
    {class} property &END: JSnapEdge read _GetEND;
    {class} property NONE: JSnapEdge read _GetNONE;
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/util/SnapEdge')]
  JSnapEdge = interface(JEnum) // or JObject // SuperSignature: java/lang/Enum
  ['{096573E9-8D0A-4724-8E5E-E79B08481E2C}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJSnapEdge = class(TJavaGenericImport<JSnapEdgeClass, JSnapEdge>) end;

  JUtilClass = interface(JObjectClass)
  ['{8FFD7538-8839-4EB6-8358-EC3D3D265AD2}']
    { static Property Methods }

    { static Methods }
    {class} function init: JUtil; cdecl; //()V
    {class} function getDP(dp: JContext; P2: Integer): Integer; cdecl; //(Landroid/content/Context;I)I
    {class} function toByteArray(os: JInputStream): TJavaArray<Byte>; cdecl; //(Ljava/io/InputStream;)[B

    { static Property }
  end;

  [JavaSignature('com/github/barteksc/pdfviewer/util/Util')]
  JUtil = interface(JObject)
  ['{0DE340E1-6659-48AB-B633-788EFA4B6CBE}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJUtil = class(TJavaGenericImport<JUtilClass, JUtil>) end;

  JPdfDocument_BookmarkClass = interface(JObjectClass)
  ['{0DEE1D52-C5A9-40F4-81D5-8A413829D2A0}']
    { static Property Methods }

    { static Methods }
    {class} function init: JPdfDocument_Bookmark; cdecl; //()V

    { static Property }
  end;

  [JavaSignature('com/shockwave/pdfium/PdfDocument$Bookmark')]
  JPdfDocument_Bookmark = interface(JObject)
  ['{E7BA7814-CF15-46DA-A743-C74F303F96C8}']
    { Property Methods }

    { methods }
    function getChildren: JList; cdecl; //()Ljava/util/List;
    function hasChildren: Boolean; cdecl; //()Z
    function getTitle: JString; cdecl; //()Ljava/lang/String;
    function getPageIdx: Int64; cdecl; //()J

    { Property }
  end;

  TJPdfDocument_Bookmark = class(TJavaGenericImport<JPdfDocument_BookmarkClass, JPdfDocument_Bookmark>) end;

  JPdfDocument_LinkClass = interface(JObjectClass)
  ['{75B9DC13-6265-4B8B-AFAA-8838DDA7E689}']
    { static Property Methods }

    { static Methods }
    {class} function init(bounds: JRectF; destPageIdx: JInteger; uri: JString): JPdfDocument_Link; cdecl; //(Landroid/graphics/RectF;Ljava/lang/Integer;Ljava/lang/String;)V

    { static Property }
  end;

  [JavaSignature('com/shockwave/pdfium/PdfDocument$Link')]
  JPdfDocument_Link = interface(JObject)
  ['{88E3172C-C08C-46FB-B1FC-E9F4A2237C7A}']
    { Property Methods }

    { methods }
    function getDestPageIdx: JInteger; cdecl; //()Ljava/lang/Integer;
    function getUri: JString; cdecl; //()Ljava/lang/String;
    function getBounds: JRectF; cdecl; //()Landroid/graphics/RectF;

    { Property }
  end;

  TJPdfDocument_Link = class(TJavaGenericImport<JPdfDocument_LinkClass, JPdfDocument_Link>) end;

  JPdfDocument_MetaClass = interface(JObjectClass)
  ['{0CA43688-3C71-4D73-B6A7-24FB150B76C1}']
    { static Property Methods }

    { static Methods }
    {class} function init: JPdfDocument_Meta; cdecl; //()V

    { static Property }
  end;

  [JavaSignature('com/shockwave/pdfium/PdfDocument$Meta')]
  JPdfDocument_Meta = interface(JObject)
  ['{8D071089-26A2-42CE-9CB2-DFF353A5AB9B}']
    { Property Methods }

    { methods }
    function getTitle: JString; cdecl; //()Ljava/lang/String;
    function getAuthor: JString; cdecl; //()Ljava/lang/String;
    function getSubject: JString; cdecl; //()Ljava/lang/String;
    function getKeywords: JString; cdecl; //()Ljava/lang/String;
    function getCreator: JString; cdecl; //()Ljava/lang/String;
    function getProducer: JString; cdecl; //()Ljava/lang/String;
    function getCreationDate: JString; cdecl; //()Ljava/lang/String;
    function getModDate: JString; cdecl; //()Ljava/lang/String;

    { Property }
  end;

  TJPdfDocument_Meta = class(TJavaGenericImport<JPdfDocument_MetaClass, JPdfDocument_Meta>) end;

  JPdfDocumentClass = interface(JObjectClass)
  ['{6358B8A6-9C5D-46E8-B641-1464F42E9AEF}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/shockwave/pdfium/PdfDocument')]
  JPdfDocument = interface(JObject)
  ['{307ADA98-9258-4377-B008-BAE7B832257A}']
    { Property Methods }

    { methods }
    function hasPage(index: Integer): Boolean; cdecl; //(I)Z

    { Property }
  end;

  TJPdfDocument = class(TJavaGenericImport<JPdfDocumentClass, JPdfDocument>) end;

  JPdfiumCoreClass = interface(JObjectClass)
  ['{F90E0362-604C-44EC-8940-74E4646B008E}']
    { static Property Methods }

    { static Methods }
    {class} function getNumFd(e: JParcelFileDescriptor): Integer; cdecl; //(Landroid/os/ParcelFileDescriptor;)I
    {class} function init(ctx: JContext): JPdfiumCore; cdecl; //(Landroid/content/Context;)V

    { static Property }
  end;

  [JavaSignature('com/shockwave/pdfium/PdfiumCore')]
  JPdfiumCore = interface(JObject)
  ['{A14D9EE4-23D4-46C6-B90C-5FC4B274DD39}']
    { Property Methods }

    { methods }
    function newDocument(fd: JParcelFileDescriptor): JPdfDocument; cdecl; overload; //(Landroid/os/ParcelFileDescriptor;)Lcom/shockwave/pdfium/PdfDocument;
    function newDocument(fd: JParcelFileDescriptor; password: JString): JPdfDocument; cdecl; overload; //(Landroid/os/ParcelFileDescriptor;Ljava/lang/String;)Lcom/shockwave/pdfium/PdfDocument;
    function newDocument(data: TJavaArray<Byte>): JPdfDocument; cdecl; overload; //([B)Lcom/shockwave/pdfium/PdfDocument;
    function newDocument(data: TJavaArray<Byte>; password: JString): JPdfDocument; cdecl; overload; //([BLjava/lang/String;)Lcom/shockwave/pdfium/PdfDocument;
    function getPageCount(doc: JPdfDocument): Integer; cdecl; //(Lcom/shockwave/pdfium/PdfDocument;)I
    function openPage(doc: JPdfDocument; pageIndex: Integer): Int64; cdecl; overload; //(Lcom/shockwave/pdfium/PdfDocument;I)J
    function openPage(doc: JPdfDocument; fromIndex: Integer; toIndex: Integer): TJavaArray<Int64>; cdecl; overload; //(Lcom/shockwave/pdfium/PdfDocument;II)[J
    function getPageWidth(doc: JPdfDocument; index: Integer): Integer; cdecl; //(Lcom/shockwave/pdfium/PdfDocument;I)I
    function getPageHeight(doc: JPdfDocument; index: Integer): Integer; cdecl; //(Lcom/shockwave/pdfium/PdfDocument;I)I
    function getPageWidthPoint(doc: JPdfDocument; index: Integer): Integer; cdecl; //(Lcom/shockwave/pdfium/PdfDocument;I)I
    function getPageHeightPoint(doc: JPdfDocument; index: Integer): Integer; cdecl; //(Lcom/shockwave/pdfium/PdfDocument;I)I
    function getPageSize(doc: JPdfDocument; index: Integer): JSize; cdecl; //(Lcom/shockwave/pdfium/PdfDocument;I)Lcom/shockwave/pdfium/util/Size;
    procedure renderPage(doc: JPdfDocument; surface: JSurface; pageIndex: Integer; startX: Integer; startY: Integer; drawSizeX: Integer; drawSizeY: Integer); cdecl; overload; //(Lcom/shockwave/pdfium/PdfDocument;Landroid/view/Surface;IIIII)V
    procedure renderPage(doc: JPdfDocument; surface: JSurface; pageIndex: Integer; startX: Integer; startY: Integer; drawSizeX: Integer; drawSizeY: Integer; renderAnnot: Boolean); cdecl; overload; //(Lcom/shockwave/pdfium/PdfDocument;Landroid/view/Surface;IIIIIZ)V
    procedure renderPageBitmap(doc: JPdfDocument; bitmap: JBitmap; pageIndex: Integer; startX: Integer; startY: Integer; drawSizeX: Integer; drawSizeY: Integer); cdecl; overload; //(Lcom/shockwave/pdfium/PdfDocument;Landroid/graphics/Bitmap;IIIII)V
    procedure renderPageBitmap(doc: JPdfDocument; bitmap: JBitmap; pageIndex: Integer; startX: Integer; startY: Integer; drawSizeX: Integer; drawSizeY: Integer; renderAnnot: Boolean); cdecl; overload; //(Lcom/shockwave/pdfium/PdfDocument;Landroid/graphics/Bitmap;IIIIIZ)V
    procedure closeDocument(doc: JPdfDocument); cdecl; //(Lcom/shockwave/pdfium/PdfDocument;)V
    function getDocumentMeta(doc: JPdfDocument): JPdfDocument_Meta; cdecl; //(Lcom/shockwave/pdfium/PdfDocument;)Lcom/shockwave/pdfium/PdfDocument$Meta;
    function getTableOfContents(doc: JPdfDocument): JList; cdecl; //(Lcom/shockwave/pdfium/PdfDocument;)Ljava/util/List;
    function getPageLinks(doc: JPdfDocument; pageIndex: Integer): JList; cdecl; //(Lcom/shockwave/pdfium/PdfDocument;I)Ljava/util/List;
    function mapPageCoordsToDevice(doc: JPdfDocument; pageIndex: Integer; startX: Integer; startY: Integer; sizeX: Integer; sizeY: Integer; rotate: Integer; pageX: Double; pageY: Double): JPoint; cdecl; //(Lcom/shockwave/pdfium/PdfDocument;IIIIIIDD)Landroid/graphics/Point;
    function mapRectToDevice(doc: JPdfDocument; pageIndex: Integer; startX: Integer; startY: Integer; sizeX: Integer; sizeY: Integer; rotate: Integer; coords: JRectF): JRectF; cdecl; //(Lcom/shockwave/pdfium/PdfDocument;IIIIIILandroid/graphics/RectF;)Landroid/graphics/RectF;

    { Property }
  end;

  TJPdfiumCore = class(TJavaGenericImport<JPdfiumCoreClass, JPdfiumCore>) end;

  JPdfPasswordExceptionClass = interface(JIOExceptionClass) // or JObjectClass // SuperSignature: java/io/IOException
  ['{B53ACED6-2043-472B-8EBD-7BE6CBBBAC7F}']
    { static Property Methods }

    { static Methods }
    {class} function init: JPdfPasswordException; cdecl; overload; //()V
    {class} function init(detailMessage: JString): JPdfPasswordException; cdecl; overload; //(Ljava/lang/String;)V

    { static Property }
  end;

  [JavaSignature('com/shockwave/pdfium/PdfPasswordException')]
  JPdfPasswordException = interface(JIOException) // or JObject // SuperSignature: java/io/IOException
  ['{234843EA-61FB-4162-9F96-01CE5B9103E2}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJPdfPasswordException = class(TJavaGenericImport<JPdfPasswordExceptionClass, JPdfPasswordException>) end;

  JSizeClass = interface(JObjectClass)
  ['{59A8DB18-A4BF-4616-8A31-F0F9B6F279FF}']
    { static Property Methods }

    { static Methods }
    {class} function init(width: Integer; height: Integer): JSize; cdecl; //(II)V

    { static Property }
  end;

  [JavaSignature('com/shockwave/pdfium/util/Size')]
  JSize = interface(JObject)
  ['{3440D003-9FD3-4912-B8A9-98665397A64F}']
    { Property Methods }

    { methods }
    function getWidth: Integer; cdecl; //()I
    function getHeight: Integer; cdecl; //()I
    function equals(obj: JObject): Boolean; cdecl; //(Ljava/lang/Object;)Z
    function toString: JString; cdecl; //()Ljava/lang/String;
    function hashCode: Integer; cdecl; //()I

    { Property }
  end;

  TJSize = class(TJavaGenericImport<JSizeClass, JSize>) end;

  JSizeFClass = interface(JObjectClass)
  ['{66B40078-37AB-46D0-9FA6-850B0B714CDE}']
    { static Property Methods }

    { static Methods }
    {class} function init(width: Single; height: Single): JSizeF; cdecl; //(FF)V

    { static Property }
  end;

  [JavaSignature('com/shockwave/pdfium/util/SizeF')]
  JSizeF = interface(JObject)
  ['{CCA88BEA-154F-474E-B707-01AA35DEE190}']
    { Property Methods }

    { methods }
    function getWidth: Single; cdecl; //()F
    function getHeight: Single; cdecl; //()F
    function equals(obj: JObject): Boolean; cdecl; //(Ljava/lang/Object;)Z
    function toString: JString; cdecl; //()Ljava/lang/String;
    function hashCode: Integer; cdecl; //()I
    function toSize: JSize; cdecl; //()Lcom/shockwave/pdfium/util/Size;

    { Property }
  end;

  TJSizeF = class(TJavaGenericImport<JSizeFClass, JSizeF>) end;

implementation

procedure RegisterTypes;
begin
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JDragPinchManager', 
    TypeInfo(Androidapi.JNI.PDFViewer.JDragPinchManager));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JFileNotFoundException', 
    TypeInfo(Androidapi.JNI.PDFViewer.JFileNotFoundException));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPageRenderingException', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPageRenderingException));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JDefaultLinkHandler', 
    TypeInfo(Androidapi.JNI.PDFViewer.JDefaultLinkHandler));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JLinkHandler', 
    TypeInfo(Androidapi.JNI.PDFViewer.JLinkHandler));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JCallbacks', 
    TypeInfo(Androidapi.JNI.PDFViewer.JCallbacks));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JOnDrawListener', 
    TypeInfo(Androidapi.JNI.PDFViewer.JOnDrawListener));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JOnErrorListener', 
    TypeInfo(Androidapi.JNI.PDFViewer.JOnErrorListener));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JOnLoadCompleteListener', 
    TypeInfo(Androidapi.JNI.PDFViewer.JOnLoadCompleteListener));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JOnPageChangeListener', 
    TypeInfo(Androidapi.JNI.PDFViewer.JOnPageChangeListener));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JOnPageErrorListener', 
    TypeInfo(Androidapi.JNI.PDFViewer.JOnPageErrorListener));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JOnPageScrollListener', 
    TypeInfo(Androidapi.JNI.PDFViewer.JOnPageScrollListener));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JOnRenderListener', 
    TypeInfo(Androidapi.JNI.PDFViewer.JOnRenderListener));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JOnTapListener', 
    TypeInfo(Androidapi.JNI.PDFViewer.JOnTapListener));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JLinkTapEvent', 
    TypeInfo(Androidapi.JNI.PDFViewer.JLinkTapEvent));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPagePart', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPagePart));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPagesLoader_GridSize', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPagesLoader_GridSize));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPagesLoader_Holder', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPagesLoader_Holder));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPagesLoader', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPagesLoader));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPdfFile', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPdfFile));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPDFView_Configurator', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPDFView_Configurator));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPDFView_ScrollDir',
    TypeInfo(Androidapi.JNI.PDFViewer.JPDFView_ScrollDir));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPDFView_State', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPDFView_State));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPDFView', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPDFView));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JRenderingHandler_1', 
    TypeInfo(Androidapi.JNI.PDFViewer.JRenderingHandler_1));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JRenderingHandler_2', 
    TypeInfo(Androidapi.JNI.PDFViewer.JRenderingHandler_2));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JRenderingHandler_RenderingTask', 
    TypeInfo(Androidapi.JNI.PDFViewer.JRenderingHandler_RenderingTask));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JRenderingHandler', 
    TypeInfo(Androidapi.JNI.PDFViewer.JRenderingHandler));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JDefaultScrollHandle_1', 
    TypeInfo(Androidapi.JNI.PDFViewer.JDefaultScrollHandle_1));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JDefaultScrollHandle', 
    TypeInfo(Androidapi.JNI.PDFViewer.JDefaultScrollHandle));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JScrollHandle', 
    TypeInfo(Androidapi.JNI.PDFViewer.JScrollHandle));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JAssetSource', 
    TypeInfo(Androidapi.JNI.PDFViewer.JAssetSource));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JByteArraySource', 
    TypeInfo(Androidapi.JNI.PDFViewer.JByteArraySource));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JDocumentSource', 
    TypeInfo(Androidapi.JNI.PDFViewer.JDocumentSource));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JFileSource', 
    TypeInfo(Androidapi.JNI.PDFViewer.JFileSource));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JInputStreamSource', 
    TypeInfo(Androidapi.JNI.PDFViewer.JInputStreamSource));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JUriSource', 
    TypeInfo(Androidapi.JNI.PDFViewer.JUriSource));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JArrayUtils', 
    TypeInfo(Androidapi.JNI.PDFViewer.JArrayUtils));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JConstants_Cache', 
    TypeInfo(Androidapi.JNI.PDFViewer.JConstants_Cache));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JConstants_Pinch', 
    TypeInfo(Androidapi.JNI.PDFViewer.JConstants_Pinch));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JConstants', 
    TypeInfo(Androidapi.JNI.PDFViewer.JConstants));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JFileUtils', 
    TypeInfo(Androidapi.JNI.PDFViewer.JFileUtils));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JFitPolicy', 
    TypeInfo(Androidapi.JNI.PDFViewer.JFitPolicy));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JMathUtils', 
    TypeInfo(Androidapi.JNI.PDFViewer.JMathUtils));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPageSizeCalculator', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPageSizeCalculator));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JSnapEdge', 
    TypeInfo(Androidapi.JNI.PDFViewer.JSnapEdge));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JUtil', 
    TypeInfo(Androidapi.JNI.PDFViewer.JUtil));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPdfDocument_Bookmark', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPdfDocument_Bookmark));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPdfDocument_Link', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPdfDocument_Link));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPdfDocument_Meta', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPdfDocument_Meta));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPdfDocument', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPdfDocument));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPdfiumCore', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPdfiumCore));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JPdfPasswordException', 
    TypeInfo(Androidapi.JNI.PDFViewer.JPdfPasswordException));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JSize', 
    TypeInfo(Androidapi.JNI.PDFViewer.JSize));
  TRegTypes.RegisterType('Androidapi.JNI.PDFViewer.JSizeF', 
    TypeInfo(Androidapi.JNI.PDFViewer.JSizeF));
end;


initialization
  RegisterTypes;

end.
