import createReactClass from 'create-react-class';
import PropTypes from 'prop-types';

TimelineComponent.ItemList = createReactClass({
  displayName: 'TimelineComponent.ItemList',
  propTypes: {
    // array of items
    items: PropTypes.array.isRequired,

    // EVENTS
    onClick: PropTypes.func
  },
  _getItemName(item) {
    var itemName = item.name;
    if (itemName.length > 25) {
      itemName = itemName.substring(0, 22) + ' ..';
    }

    return itemName;
  },
  _buildItem(item) {
    var spanClassName = 'type-label type-' + item.type;

    return (
      <li
        key={item.key}
        className={item.className}
        onClick={TimelineComponent.actions.selectItem.bind(null, item.key)}
      >
        <span className={spanClassName}>{item.type}</span> {this._getItemName(item)}
      </li>
    );
  },
  render() {
    return <ul>{this.props.items.map(this._buildItem)}</ul>;
  }
});

function scaler(value, scale) {
  var scaler = 100 / scale;
  return value / scaler;
}
