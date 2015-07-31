// ADVANCED

tinyMCE.init({
  mode : "textareas",
  theme : "advanced",
  editor_selector : "advanced",
  extended_valid_elements : "iframe[src|width|height|name|align]",
  content_css:"/stylesheets/tnymc.css",
  theme_advanced_toolbar_location : "top",
  theme_advanced_buttons1 : "bold, italic, underline, separator, sub, sup, separator, justifyleft, justifycenter, justifyright, justifyfull, separator, bullist, numlist, separator, undo, redo",
  theme_advanced_buttons2 : "styleselect, formatselect, separator, picturemanager, documentmanager, linkmanager, hr ,separator, pasteword, separator, code",
  theme_advanced_buttons3 : "",
  forced_root_block : "",
  plugins : 'paste',
  setup : function(ed) {
  	ed.onEvent.add(function(ed) {
      p_editor_storeBookmark(ed);
    });
    ed.addButton('picturemanager', {
      title : 'Picture Manager',
      image : '/images/admin/picture_manager.gif',
      onclick : function() {
        pictureManager(ed);
      }
    });
    ed.addButton('documentmanager', {
      title : 'Document Manager',
      image : '/images/admin/document_manager.gif',
      onclick : function() {
        documentManager(ed);
      }
    });
    ed.addButton('linkmanager', {
      title : 'Link Mananger',
      image : '/images/admin/link_manager.gif',
      onclick : function() {
        linkManager(ed);
      }
    });
  }
});

tinyMCE.init({
  mode : "textareas",
  theme : "simple",
  readonly : true,
  editor_selector : "advanced_readonly"
});


// BASIC

tinyMCE.init({
  mode : "textareas",
  theme : "advanced",
  theme_advanced_toolbar_location : "top",
  editor_selector : "simple",
  forced_root_block : "",
  theme_advanced_buttons1 : "bold, italic, underline, separator, justifyleft, justifycenter, justifyright, justifyfull, separator, bullist, numlist, separator, undo, redo, seperator, pasteword, seperator, code",
  theme_advanced_buttons2 : "",
  theme_advanced_buttons3 : "",
  forced_root_block : ""
});

tinyMCE.init({
  mode : "textareas",
  theme : "simple",
  readonly : true,
  editor_selector : "simple_readonly"
});

// LINKER

tinyMCE.init({
  mode : "textareas",
  theme : "advanced",
  theme_advanced_toolbar_location : "top",
  editor_selector : "linker",
  extended_valid_elements : "iframe[src|width|height|name|align]",
  forced_root_block : "",
  theme_advanced_buttons1 : "linkmanager, documentmanager, separator, pasteword, bold, italic, underline, separator, undo, redo, code",
  theme_advanced_buttons2 : "",
  theme_advanced_buttons3 : "",
  setup : function(ed) {
  	ed.onEvent.add(function(ed) {
      p_editor_storeBookmark(ed)
    });
    ed.addButton('linkmanager', {
      title : 'Link Mananger',
      image : '/images/admin/link_manager.gif',
      onclick : function() {
        linkManager(ed);
      }
    });
    ed.addButton('documentmanager', {
      title : 'Document Manager',
      image : '/images/admin/document_manager.gif',
      onclick : function() {
        documentManager(ed);
      }
    });
  }
});

tinyMCE.init({
  mode : "textareas",
  theme : "simple",
  readonly : true,
  editor_selector : "linker_readonly"
});

// this variable is used to store the cursor location to re-insert content in the right place in IE
// since IE refuse to do things like the rest of the internet.  I hate IE
p_editor_bookmark = false;

function p_editor_storeBookmark(ed) {
	ed.focus();
	//p_editor_bookmark = ed.selection.getBookmark();
}

function pictureManager(ed)
{
  if (window.tinyMCE.activeEditor != ed)
  {
    alert("Please click on the area of the editor where you would like to insert this picture before opening the picture manager");
  }
  else
  {
    var pictureManager = document.getElementById("pictureManager");
    myLytebox.start(pictureManager, false, true);
  }
}

function documentManager(ed)
{
	if (window.tinyMCE.activeEditor != ed)
  {
    alert("Please click on the area of the editor where you would like to insert this picture before opening the link manager");
  }
  else
  {
  	var element = window.tinyMCE.activeEditor.selection.getStart();
		while (element != undefined)
		{
			if (element.href != undefined)
  		{
				var documentManager = document.getElementById("documentManager");
				var linkWithParam = documentManager.cloneNode(false);
				linkWithParam.href = linkWithParam.href + ("?link=" + element.href);
			  linkWithParam.href = linkWithParam.href + ("&link_text=" + element.innerHTML);
			  window.tinyMCE.activeEditor.selection.select(element);
			  p_editor_bookmark = window.tinyMCE.activeEditor.selection.getBookmark();
			  myLytebox.start(linkWithParam, false, true);
			  return
		  }
			element = element.parentNode;
		}
  	if (window.tinyMCE.activeEditor.selection.getContent() != "")
  	{	
			var documentManager = document.getElementById("documentManager");
			var linkWithParam = documentManager.cloneNode(false);

			linkWithParam.href = linkWithParam.href + ("?link_text=" + window.tinyMCE.activeEditor.selection.getContent());
			p_editor_bookmark = window.tinyMCE.activeEditor.selection.getBookmark();
	    myLytebox.start(linkWithParam, false, true);
    }
	  else
	  {
	  	alert("Please select the text/image you would like to convert into a link");
		}
  }
}

function linkManager(ed)
{
	if (window.tinyMCE.activeEditor != ed)
  {
    alert("Please click on the area of the editor where you would like to insert this picture before opening the link manager");
  }
  else
  {
  	var element = window.tinyMCE.activeEditor.selection.getStart();
		while (element != undefined)
		{
			if (element.href != undefined)
  		{
				var linkManager = document.getElementById("linkManager");
				var linkWithParam = linkManager.cloneNode(false);
				linkWithParam.href = linkWithParam.href + ("?link=" + element.href);
			  linkWithParam.href = linkWithParam.href + ("&link_text=" + element.innerHTML);
			  window.tinyMCE.activeEditor.selection.select(element);
			  p_editor_bookmark = window.tinyMCE.activeEditor.selection.getBookmark();
			  myLytebox.start(linkWithParam, false, true);
			  return
		  }
			element = element.parentNode;
		}		
  	if (window.tinyMCE.activeEditor.selection.getContent() != "")
  	{	
			var linkManager = document.getElementById("linkManager");
			var linkWithParam = linkManager.cloneNode(false);
			linkWithParam.href = linkWithParam.href + ("?link_text=" + window.tinyMCE.activeEditor.selection.getContent());
			p_editor_bookmark = window.tinyMCE.activeEditor.selection.getBookmark();
	    myLytebox.start(linkWithParam, false, true);
    }
	  else
	  {
	  	alert("Please select the text/image you would like to convert into a link");
		}
  }
}
