/* Section 1: Definitions
 *
 * Hack Entity:
 *      A record in solr. Contains some basic information such as
 *      title, description and categories. A Hack Entity does not refer
 *      to the complete information that exists in hack api, but just
 *      that information that gets returned by solr.
 *
 * Hack Component:
 *      A React Component that implements a hack entity usually by
 *      using the Hack API to get more data about the thing and
 *      usually providing one or more actions the user can take.
 *      The Hack Component has a "Card" view that shows up in the
 *      list of search results which is returned in the components
 *      render method. It may optionally have a "Details" view that
 *      shows up when the card is opened and is returned by the
 *      open() method. This latter method must return an array of Cells.
 *
 * Hack API:
 *      The API that provides all of the async data and functionality of
 *      Hackmaster website for use withen Hack Components.
 *
 * Hack Solr:
 *      The Solr server that returns a list of relevant Hack Entities
 *      if it is provided with a search term. In this way the user
 *      can fidn the functionality he needs by simply typing into the
 *      search box.
 * */


/* Section 2: Hack Components
 * These components are react components representing hackmastertrack entities. */

class Overview extends React.Component {
    constructor(props) {
        super(props);

        this.open = this.open.bind(this);
    }

    open() {
        // TODO Use hackapi.js (yet to be created) to interface with the rails
        // json API in order to obtain the character data
        var character = {
            name: "Slighter",
            race: "Human",
            character_class: "Fighter",
            strength: 16.75,
            dexterity: 14.12,
            constitution: 11.34,
            intelligence: 12.78,
            wisdom: 8.76,
            charisma: 6.89,
            looks: 7.89
        };

        this.props.forward(
            <Cell desktop="12">
                <Grid nested={true}>
                    <Cell desktop="9" key="title">
                        <span className="mdl-typography--display-1">
                            {this.props.hackEntity.title}
                        </span>
                    </Cell>
                    <Cell desktop="4" tablet="4" phone="2" key="1">
                        <Card>
                            <CardText>
                                {character.race + " " + character.character_class}
                            </CardText>
                        </Card>
                    </Cell>
                    <Cell desktop="4" tablet="4" phone="2" key="2">
                        <Card>
                            <CardText>
                                <div>Strength: {character.strength}</div>
                                <div>Dexterity: {character.dexterity}</div>
                                <div>Constitution: {character.constitution}</div>
                                <div>Intelligence: {character.intelligence}</div>
                                <div>Wisdom: {character.wisdom}</div>
                                <div>Charisma: {character.charisma}</div>
                                <div>Looks: {character.looks}</div>
                            </CardText>
                        </Card>
                    </Cell>
                </Grid>
            </Cell>);
    }

    render() {
        return (
            <Cell desktop="3" tablet="4" phone="4">
                <Card>
                    <CardTitle>
                        {this.props.hackEntity.title}
                    </CardTitle>
                    <CardText>
                        {this.props.hackEntity.description}
                    </CardText>
                    <CardActions>
                        <Button action={this.open}>
                            Open
                        </Button>
                    </CardActions>
                </Card>
            </Cell>
        );
    }
}

/* This is a generic Hack Component that just displays the title, description
 * and category of the Hack Entity. This will be used if no other Hack Component
 * is found to match the Hack Entity. */
class Unimplemented extends React.Component {
    constructor(props) {
        super(props);

        this.open = this.open.bind(this);
    }

    open() {
        this.props.forward(
            <Cell desktop="12">
                <Grid nested={true}>
                    <Cell desktop="9" key="title">
                        <span className="mdl-typography--display-1">
                            {this.props.hackEntity.title}
                        </span>
                    </Cell>
                    <Cell desktop="3" key="description">
                        <span className="mdl-typography--headline">
                            {this.props.hackEntity.category1}
                        </span>
                    </Cell>
                </Grid>
            </Cell>);
    }

    render() {
        return (
            <Cell desktop="3" tablet="4" phone="2">
                <Card>
                    <CardTitle>
                        {this.props.hackEntity.title}
                    </CardTitle>
                    <CardText>
                        {this.props.hackEntity.description}
                    </CardText>
                    <CardActions>
                        <Button action={this.open}>
                            Open
                        </Button>
                    </CardActions>
                </Card>
            </Cell>
        );
    }
}

/* Section 3: Hack Entity to Hack Component Mapping
 * This function maps a Hack Entity to the Hack Component that implements it */

function createHackComponent(hackEntity, forward) {
    if (hackEntity.category1 === "overview") {
        return hackComponent = (
            <Overview hackEntity={hackEntity}
                      key={hackEntity.path}
                      forward={forward} />);
    } else {
        return hackComponent = (
            <Unimplemented hackEntity={hackEntity}
                           key={hackEntity.path}
                           forward={forward} />);
    }
}

/* Section 4: MDL Components
 * These components are React.Components representing MDL Componentes. */

class CardTitle extends React.Component {
    render() {
        return (
            <div className="mdl-card__title mdl-card--expand">
                <h2 className="mdl-card__title-text">
                    {this.props.children}
                </h2>
            </div>
        );
    }
}

class CardText extends React.Component {
    render() {
        return (
            <div className="mdl-card__supporting-text">
                {this.props.children}
            </div>
        );
    }
}

class CardActions extends React.Component {
    render() {
        return (
            <div className="mdl-card__actions mdl-card--border">
                {this.props.children}
            </div>
        );
    }
}

class Button extends React.Component {
    render() {
        return (
            <a onClick={this.props.action} className="mdl-button mdl-button--colored">
                {this.props.children}
            </a>
        );
    }
}

class BackButton extends React.Component {
    render() {
        return (
            <button className="mdl-button mdl-js-button mdl-button--icon back">
                <i className="material-icons" onClick={this.props.action}>arrow_back</i>
            </button>
        );
    }
}

class Cell extends React.Component {
    cellClass() {
        var cellClasses = ["mdl-cell"];

        if (this.props.desktop === 0) {
            cellClasses.push("mdl-cell--hide-desktop");
        } else {
            cellClasses.push("mdl-cell--"+this.props.desktop+"-col-desktop");
        }

        if (this.props.tablet === 0) {
            cellClasses.push("mdl-cell--hide-tablet");
        } else {
            cellClasses.push("mdl-cell--"+this.props.tablet+"-col-tablet");
        }

        if (this.props.phone === 0) {
            cellClasses.push("mdl-cell--hide-phone");
        } else {
            cellClasses.push("mdl-cell--"+this.props.phone+"-col-phone");
        }

        return cellClasses.join(" ");
    }

    render() {
        return (
            <div className={this.cellClass()}>
                {this.props.children}
            </div>
        );
    }
}

class Card extends React.Component {
    render() {
        return (
            <div className="mdl-card hack-full-card mdl-shadow--2dp">
                {this.props.children}
            </div>
        );
    }
}

class Search extends React.Component {
    constructor(props) {
        super(props);

        this.state = {terms: ''};

        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
    }

    componentDidMount() {
        componentHandler.upgradeElement(this.textInput);
    }

    handleChange(e) {
        this.setState({terms: e.target.value});
    }

    handleSubmit(e) {
        e.preventDefault();
        var self = this;

        HackSolr.search(this.state.terms, { owners: ["2"], groups: ["everyone"] }, function(hackEntities) {
            var searchResultCards = [];

            $.each(hackEntities, function(index, hackEntity) {
                searchResultCards.push(createHackComponent(hackEntity, self.props.forward));
            });

            var searchResults = (
                <Cell desktop="12">
                    <Grid nested={true}>
                        {searchResultCards}
                    </Grid>
                </Cell>
            );

            self.props.forward(searchResults);
        });
    }

    render() {
        return (
            <form onSubmit={this.handleSubmit}>
                <div className="mdl-textfield mdl-js-textfield" ref={(input) => { this.textInput = input; }}>
                    <input className="mdl-textfield__input" type="text" id="hack-search" onChange={this.handleChange} />
                    <label className="mdl-textfield__label" htmlFor="hack-search">Search for anything...</label>
                </div>
            </form>
        )
    }
}

class Grid extends React.Component {
    render() {
        var className = "mdl-grid";

        if (this.props.nested === true) {
            className += " mdl-grid--nesting";
        }

        return (
            <div className={className}>
                {this.props.children}
            </div>
        );
    }
}

class Content extends React.Component {
    constructor(props) {
        super(props);

        this.backToStart = this.backToStart.bind(this);
        this.forward = this.forward.bind(this);
        this.backward = this.backward.bind(this);
        this.cells = this.cells.bind(this);

        this.state = { };

        this.state.startCards =  (
            <Cell desktop="12">
                <Grid nested={true}>
                    {this.props.startHackEntities.map((hackEntity) =>
                         createHackComponent(hackEntity, this.forward))}
                </Grid>
            </Cell>
        );

        this.state.history = [ ];
        this.state.history.push(this.state.startCards);
    }

    backToStart() {
        this.forward(this.state.startCards);
    }

    forward(cells) {
        if (this.state.history.length < 40) {
            this.state.history.push(cells);
            this.forceUpdate();
        } else {
            this.setState(function(prevState, props) {
                var newHistory = prevState.history.slice(prevState.history.length / 2);
                newHistory.push(cells);
                return { history: newHistory };
            });
        }
    }

    backward() {
        this.state.history.pop();
        this.forceUpdate();
    }

    cells() {
        return this.state.history[this.state.history.length-1];
    }

    render() {
        return(
            <main className="mdl-layout__content">
                <Grid>
                    <Cell desktop="2" tablet="2" phone="0">
                        {this.state.history.length > 1 && <BackButton action={this.backward} />}
                    </Cell>
                    <Cell desktop="2" tablet="0" phone="0" />
                    <Cell desktop="4" tablet="4" phone="4">
                        <Search forward={this.forward} />
                    </Cell>
                    <Cell desktop="4" tablet="2" phone="0" />
                    {this.cells()}
                </Grid>
            </main>
        );
    }
}

class IconLink extends React.Component {
    render() {
        return (
          <a className="mdl-navigation__link" href={this.props.href}>
            <i className="material-icons">{this.props.icon}</i>
            Character
          </a>
        );
    }
}

class Link extends React.Component {
    render() {
        return (
            <span className="mdl-layout__link">
                <a className="mdl-navigation__link" href={this.props.href}>{this.props.title}</a>
            </span>
        );
    }
}

class Drawer extends React.Component {
    render() {
      return (
        <div className="mdl-layout__drawer">
            <span className="mdl-layout__title">{this.props.title}</span>
            <nav className="mdl-navigation">
              <IconLink href="/characters/step1" icon="add" />
            </nav>
        </div>
      );
    }
}


class Header extends React.Component {
    constructor(props) {
        super(props);
        this.state = { };

        this.state.characterName = "Slighter";
    }

    render() {
        return (
          <header className="mdl-layout__header">
            <div className="mdl-layout__header-row">
              <span className="mdl-layout__title">
                {this.state.characterName}
              </span>
              <div className="mdl-layout-spacer"></div>
              <Link href="/" title="Classic Version" />
            </div>
          </header>
        )
    }
}

class Layout extends React.Component {
    render() {
        return (
            <div className="mdl-layout mdl-js-layout mdl-layout--fixed-drawer mdl-layout--fixed-header mdl-color-text--grey-600 main-layout">
                <Header />
                <Drawer title={this.props.title} />
                <Content startHackEntities={this.props.startHackEntities} />
            </div>
        );
    }
}

$(document).ready(function() {
    var startHackEntities = [
        {
            name: "overview",
            category1: "overview",
            title: "Overview",
            description: "Your characters race, class, ability scores, money, health and experience.",
        },
        {
            name: "combat",
            category1: "combat",
            title: "Combat",
            description: "Your combat values and equiped weapon / armor sets.",
        },
        {
            name: "spells",
            category1: "spells",
            title: "Spells",
            description: "Your spells. Lorem ipsum...",
        },
        {
            name: "equipment",
            category1: "equipment",
            title: "Equipment",
            description: "Your characters weapons, armor and inventory.",
        },
        {
            name: "proficiencies",
            category1: "proficiencies",
            title: "Proficiencies",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "specializations",
            category1: "specializations",
            title: "Specializations",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "talents",
            category1: "talents",
            title: "Talents",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "skills",
            category1: "skills",
            title: "Skills",
            description: "Your talents, proficiencies, skills, and .",
        }
    ];

    var layout = <Layout startHackEntities={startHackEntities} title="Hacktrack" />;
    ReactDOM.render(layout, document.getElementById('react-root'));
});
