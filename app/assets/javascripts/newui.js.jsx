class CardTitle extends React.Component {
    render() {
        return (
            <div className="mdl-card__title mdl-card--expand">
                <h2 className="mdl-card__title-text">{this.props.text}</h2>
            </div>
        );
    }
}

class CardText extends React.Component {
    render() {
        return (
            <div className="mdl-card__supporting-text">
                {this.props.text}
            </div>
        );
    }
}

class CardActions extends React.Component {
    render() {
        return (
            <div className="mdl-card__actions mdl-card--border">
                <a onClick={this.props.open} className="mdl-button mdl-button--colored">
                    Open
                </a>
            </div>
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

class OptionCard extends React.Component {
    constructor(props) {
        super(props);

        this.open = this.open.bind(this);
    }

    open() {
        // TODO manage this detailsGrid variable in the state so that we can destroy it when needed.
        var detailsGrid = (
        <Grid showCards={this.props.showCards}
              closeDetailsGrid={this.props.closeDetailsGrid}
              openDetailsGrid={this.props.openDetailsGrid}>
            <Cell desktop="6">
                <span className="mdl-typography--display-1">
                    {this.props.tile.title}
                </span>
            </Cell>
            <Cell desktop="6">
                <span className="mdl-typography--headline">
                    {this.props.tile.description}
                </span>
            </Cell>
        </Grid>);

        this.props.openDetailsGrid(detailsGrid);
    }

    render() {
        return (
            <Cell desktop="3" tablet="4" phone="2">
                <div className="mdl-card hack-full-card mdl-shadow--2dp">
                    <CardTitle text={this.props.tile.title} />
                    <CardText text={this.props.tile.description}/>
                    <CardActions open={this.open} />
                </div>
            </Cell>
        );
    }
}

class Search extends React.Component {
    constructor(props) {
        super(props);

        this.search = this.search.bind(this);
    }

    componentDidMount() {
        componentHandler.upgradeElement(this.textInput);
    }

    search(e) {
        e.preventDefault();

        var exampleSearchResults = [
            {
                name: "sword",
                title: "Sword",
                description: "An awesome weapon."
            },
            {
                name: "fireball",
                title: "Fireball",
                description: "A powerful spell."
            },
            {
                name: "longsword-proficiency",
                title: "Longsword Proficiency",
                description: "Learn the longword"
            },
            {
                name: "axe",
                title: "Axe",
                description: "Weapon of greatness"
            }
        ];

        var random1 = parseInt(Math.floor(Math.random() * 4));
        var random2 = parseInt(Math.floor(Math.random() * 4));

        var searchResultCards = []
        searchResultCards.push(<OptionCard tile={exampleSearchResults[random1]}
              key={exampleSearchResults[random1].name}
              showCards={this.props.showCards}
              closeDetailsGrid={this.props.closeDetailsGrid}
              openDetailsGrid={this.props.openDetailsGrid} />);
        searchResultCards.push(<OptionCard tile={exampleSearchResults[random2]}
              key={exampleSearchResults[random2].name}
              showCards={this.props.showCards}
              closeDetailsGrid={this.props.closeDetailsGrid}
              openDetailsGrid={this.props.openDetailsGrid} />);

        this.props.showCards(searchResultCards);
    }

    render() {
        return (
            <form onSubmit={this.search}>
                <div className="mdl-textfield mdl-js-textfield" ref={(input) => { this.textInput = input; }}>
                    <input className="mdl-textfield__input" type="text" id="hack-search" />
                    <label className="mdl-textfield__label" htmlFor="hack-search">Search for anything...</label>
                </div>
            </form>
        )
    }
}

class Grid extends React.Component {
    render() {
        return (
            <div className="mdl-grid">
                <Cell desktop="2" tablet="2" phone="0">
                    <BackButton action={this.props.closeDetailsGrid} />
                </Cell>
                <Cell desktop="2" tablet="0" phone="0" />
                <Cell desktop="4" tablet="4" phone="4">
                    <Search showCards={this.props.showCards}
                            closeDetailsGrid={this.props.closeDetailsGrid}
                            openDetailsGrid={this.props.openDetailsGrid} />
                </Cell>
                <Cell desktop="4" tablet="2" phone="0" />
                {this.props.children}
            </div>
        );
    }
}

class Content extends React.Component {
    constructor(props) {
        super(props);

        this.backToStart = this.backToStart.bind(this);
        this.showCards = this.showCards.bind(this);
        this.openDetailsGrid = this.openDetailsGrid.bind(this);
        this.closeDetailsGrid = this.closeDetailsGrid.bind(this);

        this.state = { };

        this.state.detailsOpen = false;

        this.state.startCards = this.props.startTiles.map((tile) =>
            <OptionCard tile={tile}
                  key={tile.name}
                  showCards={this.showCards}
                  closeDetailsGrid={this.closeDetailsGrid}
                  openDetailsGrid={this.openDetailsGrid} />
        );

        this.state.cells = this.state.startCards;
    }

    backToStart() {
        this.setState({
            cells: this.state.startCards
        });
    }

    showCards(cells) {
        this.closeDetailsGrid();
        this.setState({
            cells: cells
        });
    }

    openDetailsGrid(detailsGrid) {
        this.setState({
            detailsGrid: detailsGrid,
            detailsOpen: true
        });
    }

    closeDetailsGrid() {
        this.setState({
            detailsOpen: false
        });
    }

    render() {
        var grid;

        if (this.state.detailsOpen) {
            grid = this.state.detailsGrid;
        } else {
            grid = (
            <Grid showCards={this.showCards}
                  openDetailsGrid={this.openDetailsGrid}
                  closeDetailsGrid={this.closeDetailsGrid}>
                {this.state.cells}
            </Grid>);
        }

        return(
            <main className="mdl-layout__content">
                {grid}
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
                <Content startTiles={this.props.startTiles} />
            </div>
        );
    }
}

$(document).ready(function() {
    var startTiles = [
        {
            name: "overview",
            title: "Overview",
            description: "Your characters race, class, ability scores, money, health and experience.",
        },
        {
            name: "combat",
            title: "Combat",
            description: "Your combat values and equiped weapon / armor sets.",
        },
        {
            name: "spells",
            title: "Spells",
            description: "Your spells. Lorem ipsum...",
        },
        {
            name: "equipment",
            title: "Equipment",
            description: "Your characters weapons, armor and inventory.",
        },
        {
            name: "proficiencies",
            title: "Proficiencies",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "specializations",
            title: "Specializations",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "talents",
            title: "Talents",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "skills",
            title: "Skills",
            description: "Your talents, proficiencies, skills, and .",
        }
    ];

    var layout = <Layout startTiles={startTiles} title="Hacktrack" />;
    ReactDOM.render(layout, document.getElementById('react-root'));
});
