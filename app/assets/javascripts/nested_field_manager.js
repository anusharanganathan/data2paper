'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var NestedFieldManager = function () {
    function NestedFieldManager(element, options) {
        _classCallCheck(this, NestedFieldManager);

        this.element = $(element);
        this.options = options;
        this.warningClass = options.warningClass;
        this.listClass = options.listClass;
        this.fieldWrapperClass = options.fieldWrapperClass;
        this.removeInputClass = options.removeInputClass;

        this.init();
    }

    _createClass(NestedFieldManager, [{
        key: 'init',
        value: function init() {
            // this._addInitialClasses();
            this._addAriaLiveRegions();
            this._attachEvents();
            this._addCallbacks();
        }
    }, {
        key: '_addAriaLiveRegions',
        value: function _addAriaLiveRegions() {
            $(this.element).find('.listing').attr('aria-live', 'polite');
        }
    }, {
        key: '_attachEvents',
        value: function _attachEvents() {
            var _this = this;

            this.element.on('click', '.remove', function (e) {
                return _this.removeFromList(e);
            });
            this.element.on('click', '.add', function (e) {
                return _this.addToList(e);
            });
        }
    }, {
        key: '_addCallbacks',
        value: function _addCallbacks() {
            this.element.bind('manage_nested_fields:add', this.options.add);
            this.element.bind('manage_nested_fields:remove', this.options.remove);
        }
    }, {
        key: 'addToList',
        value: function addToList(event) {
            event.preventDefault();
            var $listing = $(event.target).closest('.multi-nested').find(this.listClass);
            var $listElements = $listing.children('li');
            var $activeField = $listElements.last();
            var $newId = $listElements.length;
            var $currentId = $newId - 1;
            if (this.inputIsEmpty($activeField)) {
                this.displayEmptyWarning();
                $activeField.removeAttr('style');
                // $activeField.find('.remove-box').val('0');
            } else {
                this.clearEmptyWarning();
                $listing.append(this._newField($activeField, $currentId, $newId));
            }
            this._manageFocus();
        }
    }, {
        key: 'inputIsEmpty',
        value: function inputIsEmpty($activeField) {
            var $children = $activeField.find('.form-control').not(':hidden');
            var empty = 0;
            $children.each(function () {
                if ($.trim(this.value) === "") empty++;
            });
            return empty == $children.length;
        }
    }, {
        key: 'clearEmptyWarning',
        value: function clearEmptyWarning() {
            var $listing = $(this.listClass, this.element);
            $listing.children(this.warningClass).remove();
        }
    }, {
        key: 'displayEmptyWarning',
        value: function displayEmptyWarning() {
            var $listing = $(this.listClass, this.element);
            var $warningMessage = $("<div class=\'message has-warning\'>cannot add another with empty field</div>");
            $listing.children(this.warningClass).remove();
            $listing.append($warningMessage);
        }
    }, {
        key: '_newField',
        value: function _newField($activeField, $currentId, $newId) {
            var $newField = this.createNewField($activeField, $currentId, $newId);
            return $newField;
        }
    }, {
        key: '_manageFocus',
        value: function _manageFocus() {
            $(this.element).find(this.listClass).children('li:visible:last').find('.form-control').filter(':visible:first').focus();
        }
    }, {
        key: 'createNewField',
        value: function createNewField($activeField, $currentId, $newId) {
            var $newField = $activeField.clone();
            $newField;
            this.updateIndexInLabel($newField, $currentId, $newId);
            var $newChildren = $newField.find('.form-control');
            $newChildren.val('').removeProp('required').removeAttr('style');
            this.updateIndexInId($newChildren, $currentId, $newId);
            this.updateIndexInName($newChildren, $currentId, $newId);
            $newChildren.first().focus();
            this.element.trigger("manage_nested_fields:add", $newChildren.first());
            return $newField;
        }
    }, {
        key: 'updateIndexInLabel',
        value: function updateIndexInLabel($newField, $currentId, $newId) {
            // Modify name in label
            var currentLabelPart = 'attributes_' + $currentId + '_';
            var newLabelPart = 'attributes_' + $newId + '_';
            $newField.find('label').each(function () {
                var currentLabel = $(this).attr('for');
                var newLabel = currentLabel.replace(currentLabelPart, newLabelPart);
                $(this).attr('for', newLabel);
            });
            return $newField;
        }
    }, {
        key: 'updateIndexInId',
        value: function updateIndexInId($newChildren, $currentId, $newId) {
            // modify id and name in newChildren
            var $currentIdPart = new RegExp('attributes_' + $currentId + '_');
            var $newIdPart = 'attributes_' + $newId + '_';
            $newChildren.each(function () {
                var $currentId = $(this).attr('id');
                var $newId = $currentId.replace($currentIdPart, $newIdPart);
                $(this).attr('id', $newId);
            });
            return $newChildren;
        }
    }, {
        key: 'updateIndexInName',
        value: function updateIndexInName($newChildren, $currentId, $newId) {
            // modify id and name in newChildren
            var $currentNamePart = new RegExp('[' + $currentId + ']');
            var $newnamePart = '[' + $newId + ']';
            $newChildren.each(function () {
                var $currentName = $(this).attr('name');
                var $newName = $currentName.replace($currentNamePart, $newnamePart);
                $(this).attr('name', $newName);
            });
            return $newChildren;
        }
    }, {
        key: 'removeFromList',
        value: function removeFromList(event) {
            event.preventDefault();
            var $activeField = $(event.target).parents(this.fieldWrapperClass);
            $activeField.find(this.removeInputClass).val('1');
            $activeField.hide();
            this._manageFocus();
        }
    }]);

    return NestedFieldManager;
}();