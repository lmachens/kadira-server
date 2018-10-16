import createReactClass from 'create-react-class';
import PropTypes from 'prop-types';

TimelineComponent.TraceTimeBar = createReactClass({
  displayName: 'TimelineComponent.TraceTimeBar',
  propTypes: {
    maxSectionWidth: PropTypes.number.isRequired,
    sectionHeight: PropTypes.number.isRequired,
    sectionPadding: PropTypes.number.isRequired,
    sections: PropTypes.array.isRequired
  },
  componentWillMount() {
    // find the max time in the sections. Usefull getting the width
    var maxItem = _.max(this.props.sections, s => s.time);
    this.maxTime = maxItem.time;

    // find the full height of the system
    var perSectionHeight = this.props.sectionHeight + this.props.sectionPadding;
    this.height = this.props.sections.length * perSectionHeight;
  },
  _getWidth(time) {
    return time * this.props.maxSectionWidth / this.maxTime;
  },
  _buildSectionBar(section, index) {
    var timeWidth = this._getWidth(section.time);
    var y = index * this.props.sectionHeight + index * this.props.sectionPadding;
    var caption = `${section.name} (${section.time.toFixed(0)}ms)`;
    return (
      <svg key={index}>
        <rect
          x={0}
          y={y}
          width={timeWidth}
          height={this.props.sectionHeight}
          fill={TimelineComponent.colorsForSections[section.name]}
        />

        <text x={timeWidth + 10} y={y + this.props.sectionHeight - 1} fontSize="13px" fill="gray">
          {caption}
        </text>
      </svg>
    );
  },
  render() {
    return (
      <svg width="100%" height={this.height}>
        {this.props.sections.map(this._buildSectionBar)}
      </svg>
    );
  }
});
