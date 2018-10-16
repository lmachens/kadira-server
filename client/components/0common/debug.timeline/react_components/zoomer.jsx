import createReactClass from 'create-react-class';
import PropTypes from 'prop-types';

TimelineComponent.Zoomer = createReactClass({
  propTypes: {
    // initial scale of the zoomer
    initialScale: PropTypes.number.isRequired,

    // EVENTS
    onChange: PropTypes.func
  },
  getInitialState() {
    var state = { scale: this.props.initialScale };
    return state;
  },
  _fireScaleChange(newScale) {
    this.setState({ scale: newScale });
    if (newScale > 0) {
      TimelineComponent.actions.changeZoomScale(newScale);
    }
  },
  _changeZoom(amount) {
    var newScale = this.state.scale + amount;

    // set zoom limit
    if (newScale > 0 && newScale < 520) {
      this._fireScaleChange(newScale);
    }
  },
  _resetZoom() {
    this._fireScaleChange(this.props.initialScale);
  },
  render() {
    return (
      <div>
        <div className="zoom-ctrl pull-right">
          <button className="btn-zoom-in" onClick={this._changeZoom.bind(this, 20)}>
            <span className="glyphicon glyphicon-zoom-in" />
          </button>
          <div className="scale-label">{this.state.scale}%</div>
          <button className="btn-zoom-out" onClick={this._changeZoom.bind(this, -20)}>
            <span className="glyphicon glyphicon-zoom-out" />
          </button>
          <button className="btn-zoom-reset" onClick={this._resetZoom}>
            RESET
          </button>
        </div>
        <div className="clearfix" />
      </div>
    );
  }
});
