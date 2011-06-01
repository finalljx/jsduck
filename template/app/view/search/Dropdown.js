/**
 * Renders search results list.
 */
Ext.define('Docs.view.search.Dropdown', {
    extend: 'Ext.view.View',
    alias: 'widget.searchdropdown',

    floating: true,
    autoShow: false,
    autoRender: true,
    toFrontOnShow: true,
    focusOnToFront: false,

    store: 'Search',

    id: 'search-dropdown',
    overItemCls:'x-view-over',
    trackOver: true,
    itemSelector:'div.item',
    singleSelect: true,

    tpl: new Ext.XTemplate(
        '<tpl for=".">',
            '<div class="item {type}">',
                '<div class="title">{member}</div>',
                '<div class="class">{cls}</div>',
            '</div>',
        '</tpl>'
    )
});
